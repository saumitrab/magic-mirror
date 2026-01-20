#!/bin/bash

# Magic Mirror Setup Script
echo "--- Magic Mirror Setup ---"

# 1. Check for ComfyUI Core
if [ ! -f "main.py" ]; then
    echo "Cloning ComfyUI core..."
    git clone https://github.com/comfyanonymous/ComfyUI.git .temp_comfy
    # Move everything from .temp_comfy to current dir (including hidden files)
    cp -rn .temp_comfy/* .
    cp -rn .temp_comfy/.* . 2>/dev/null
    rm -rf .temp_comfy
else
    echo "ComfyUI core already present."
fi

# 2. Virtual Environment
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# 3. Install Dependencies
echo "Installing dependencies..."
source venv/bin/activate
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi
# Magic Mirror Core dependencies
pip install opencv-python torch numpy torchvision gguf

# 4. Install Custom Nodes
echo "Installing custom nodes..."
mkdir -p custom_nodes
if [ ! -d "custom_nodes/ComfyUI-GGUF" ]; then
    echo "Cloning ComfyUI-GGUF..."
    git clone https://github.com/city96/ComfyUI-GGUF custom_nodes/ComfyUI-GGUF
else
    echo "ComfyUI-GGUF already installed."
fi

# 5. Download Flux Schnell GGUF Models
# UNET
UNET_DIR="models/unet"
UNET_FILE="$UNET_DIR/flux1-schnell-Q4_0.gguf"
UNET_URL="https://huggingface.co/city96/FLUX.1-schnell-gguf/resolve/main/flux1-schnell-Q4_0.gguf"

# CLIP/T5
# CLIP/T5
CLIP_DIR="models/clip"
# Using verified public URLs from comfyanonymous/flux_text_encoders
T5_FILE="$CLIP_DIR/t5xxl_fp8_e4m3fn.safetensors"
T5_URL="https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors"
CLIP_FILE="$CLIP_DIR/clip_l.safetensors"
CLIP_URL="https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"

# VAE
VAE_DIR="models/vae"
VAE_FILE="$VAE_DIR/ae.safetensors"
# Using a public mirror for VAE as the official BFL one is gated
VAE_URL="https://huggingface.co/camenduru/FLUX.1-dev/resolve/main/ae.safetensors"

mkdir -p "$UNET_DIR" "$CLIP_DIR" "$VAE_DIR"

# Helper to download and verify
download_model() {
    local url=$1
    local file=$2
    local name=$3
    local min_size=$4  # Minimum expected file size in bytes

    # Delete if file is suspiciously small (likely error page or corrupted)
    if [ -f "$file" ]; then
        local size=$(wc -c < "$file")
        if [ $size -lt 1000000 ]; then
            echo "⚠️  Removing corrupted/small file: $file ($size bytes)"
            rm "$file"
        fi
    fi

    if [ ! -f "$file" ]; then
        echo "Downloading $name..."
        curl -L --fail --progress-bar "$url" -o "$file"

        # Verify download succeeded
        if [ $? -ne 0 ]; then
            echo "❌ Download failed for $name"
            rm -f "$file"
            return 1
        fi

        # Check if file is HTML error page
        if file "$file" | grep -q "HTML"; then
            echo "❌ Downloaded file is HTML (likely error page), not a model file"
            rm "$file"
            return 1
        fi

        # Check minimum size if provided
        if [ -n "$min_size" ]; then
            local downloaded_size=$(wc -c < "$file")
            if [ $downloaded_size -lt $min_size ]; then
                echo "❌ Downloaded file too small ($downloaded_size bytes, expected at least $min_size bytes)"
                rm "$file"
                return 1
            fi
        fi

        echo "✅ Successfully downloaded $name"
    else
        echo "✓ $name already present."
    fi

    return 0
}

# Download models with size verification (sizes in bytes)
# UNET: ~7GB, T5: ~4.5GB, CLIP: ~200MB, VAE: ~300MB
download_model "$UNET_URL" "$UNET_FILE" "Flux Schnell UNET" 5000000000     # 5GB min
download_model "$T5_URL" "$T5_FILE" "T5 Encoder" 3000000000                # 3GB min
download_model "$CLIP_URL" "$CLIP_FILE" "CLIP-L" 100000000                 # 100MB min
download_model "$VAE_URL" "$VAE_FILE" "Flux VAE" 200000000                 # 200MB min

echo "Setup complete!"
