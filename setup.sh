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
pip install opencv-python torch numpy torchvision

# 4. Download SDXL Turbo Model (Action Required for magic mirror)
MODEL_DIR="models/checkpoints"
MODEL_FILE="$MODEL_DIR/sd_xl_turbo_1.0_fp16.safetensors"
MODEL_URL="https://huggingface.co/stabilityai/sdxl-turbo/resolve/main/sd_xl_turbo_1.0_fp16.safetensors"

mkdir -p "$MODEL_DIR"

if [ ! -f "$MODEL_FILE" ]; then
    echo "Downloading SDXL Turbo model (~7GB)... This may take a while."
    echo "If it fails, you can manually place the file in $MODEL_DIR"
    curl -L "$MODEL_URL" -o "$MODEL_FILE"
else
    echo "SDXL Turbo model already present."
fi

echo "Setup complete!"
