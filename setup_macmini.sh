#!/bin/bash

# Magic Mirror Setup Script for Mac Mini (32GB RAM)
# Optimized for Flux Schnell + IP-Adapter
echo "--- Magic Mirror Setup (Mac Mini - High Performance) ---"

# 1. Run base setup
if [ -f "setup.sh" ]; then
    echo "Running base setup..."
    bash setup.sh
else
    echo "Error: setup.sh not found"
    exit 1
fi

# 2. Activate virtual environment
source venv/bin/activate

# 3. Install ComfyUI IP-Adapter nodes
if [ ! -d "custom_nodes/ComfyUI_IPAdapter_plus" ]; then
    echo "Installing ComfyUI IP-Adapter Plus nodes..."
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus custom_nodes/ComfyUI_IPAdapter_plus
else
    echo "ComfyUI IP-Adapter Plus already installed."
fi

# Install IP-Adapter dependencies
echo "Installing IP-Adapter dependencies..."
pip install insightface onnxruntime

# 4. Setup IP-Adapter directories
IPADAPTER_DIR="models/ipadapter"
CLIP_VISION_DIR="models/clip_vision"
mkdir -p "$IPADAPTER_DIR" "$CLIP_VISION_DIR"

# Helper to download and verify (same as setup.sh)
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

# 5. Download IP-Adapter models for Flux
echo ""
echo "Downloading IP-Adapter models for Flux..."

# CLIP Vision encoder (shared between SD 1.5 and Flux)
CLIP_VISION_FILE="$CLIP_VISION_DIR/CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors"
CLIP_VISION_URL="https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors"

# IP-Adapter Plus for SDXL (can work with Flux Schnell in some setups)
IPADAPTER_FILE="$IPADAPTER_DIR/ip-adapter-plus_sdxl_vit-h.safetensors"
IPADAPTER_URL="https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter-plus_sdxl_vit-h.safetensors"

download_model "$CLIP_VISION_URL" "$CLIP_VISION_FILE" "CLIP Vision Encoder" 1000000000  # 1GB min
download_model "$IPADAPTER_URL" "$IPADAPTER_FILE" "IP-Adapter Plus (SDXL/Flux)" 500000000  # 500MB min

echo ""
echo "✅ Mac Mini setup complete!"
echo ""
echo "Your system is configured for high-quality Flux Schnell generation with face preservation."
echo "To start: ./run_macmini.command"
