#!/bin/bash

# Magic Mirror Setup Script for MacBook Air (8GB RAM)
# Optimized for SD 1.5 Turbo + IP-Adapter (lightweight)
echo "--- Magic Mirror Setup (MacBook Air - Lightweight) ---"

# 1. Check for ComfyUI Core
if [ ! -f "main.py" ]; then
    echo "Cloning ComfyUI core..."
    git clone https://github.com/comfyanonymous/ComfyUI.git .temp_comfy
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
pip install opencv-python torch numpy torchvision

# 4. Install ComfyUI IP-Adapter nodes
if [ ! -d "custom_nodes/ComfyUI_IPAdapter_plus" ]; then
    echo "Installing ComfyUI IP-Adapter Plus nodes..."
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus custom_nodes/ComfyUI_IPAdapter_plus
else
    echo "ComfyUI IP-Adapter Plus already installed."
fi

# Install IP-Adapter dependencies
echo "Installing IP-Adapter dependencies..."
pip install insightface onnxruntime

# 5. Setup directories
CHECKPOINTS_DIR="models/checkpoints"
IPADAPTER_DIR="models/ipadapter"
CLIP_VISION_DIR="models/clip_vision"
VAE_DIR="models/vae"
mkdir -p "$CHECKPOINTS_DIR" "$IPADAPTER_DIR" "$CLIP_VISION_DIR" "$VAE_DIR"

# Helper to download and verify
download_model() {
    local url=$1
    local file=$2
    local name=$3
    local min_size=$4

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

        if [ $? -ne 0 ]; then
            echo "❌ Download failed for $name"
            rm -f "$file"
            return 1
        fi

        if file "$file" | grep -q "HTML"; then
            echo "❌ Downloaded file is HTML (likely error page), not a model file"
            rm "$file"
            return 1
        fi

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

# 6. Download SD 1.5 models
echo ""
echo "Downloading SD 1.5 models (lightweight, ~4GB total)..."

# SD 1.5 base model (or use a faster variant like Realistic Vision)
SD15_FILE="$CHECKPOINTS_DIR/realisticVisionV51_v51VAE.safetensors"
SD15_URL="https://huggingface.co/SG161222/Realistic_Vision_V5.1_noVAE/resolve/main/Realistic_Vision_V5.1.safetensors"

# CLIP Vision encoder (shared)
CLIP_VISION_FILE="$CLIP_VISION_DIR/CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
CLIP_VISION_URL="https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors"

# IP-Adapter for SD 1.5 (face-focused, lightweight)
IPADAPTER_FILE="$IPADAPTER_DIR/ip-adapter-plus-face_sd15.bin"
IPADAPTER_URL="https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus-face_sd15.bin"

download_model "$SD15_URL" "$SD15_FILE" "SD 1.5 (Realistic Vision)" 2000000000        # 2GB min
download_model "$CLIP_VISION_URL" "$CLIP_VISION_FILE" "CLIP Vision Encoder" 1000000000  # 1GB min
download_model "$IPADAPTER_URL" "$IPADAPTER_FILE" "IP-Adapter Face (SD 1.5)" 50000000  # 50MB min

echo ""
echo "✅ MacBook Air setup complete!"
echo ""
echo "Your system is configured for lightweight SD 1.5 generation with face preservation."
echo "This setup uses ~6-7GB RAM and is optimized for 8GB systems."
echo "To start: ./run_macbook.command"
