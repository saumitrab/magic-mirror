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
CLIP_DIR="models/clip"
T5_FILE="$CLIP_DIR/t5-v1_1-xxl-encoder-Q3_K_M.gguf"
T5_URL="https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/t5-v1_1-xxl-encoder-Q3_K_M.gguf"
CLIP_FILE="$CLIP_DIR/clip_l.safetensors"
CLIP_URL="https://huggingface.co/comfyanonymous/flux_all_in_one/resolve/main/clip_l.safetensors"

# VAE
VAE_DIR="models/vae"
VAE_FILE="$VAE_DIR/flux_ae.safetensors"
VAE_URL="https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/vae/diffusion_pytorch_model.safetensors"

mkdir -p "$UNET_DIR" "$CLIP_DIR" "$VAE_DIR"

if [ ! -f "$UNET_FILE" ]; then
    echo "Downloading Flux Schnell UNET (~7GB)..."
    curl -L "$UNET_URL" -o "$UNET_FILE"
fi

if [ ! -f "$T5_FILE" ]; then
    echo "Downloading T5 Encoder (~5GB)..."
    curl -L "$T5_URL" -o "$T5_FILE"
fi

if [ ! -f "$CLIP_FILE" ]; then
    echo "Downloading CLIP-L (~300MB)..."
    curl -L "$CLIP_URL" -o "$CLIP_FILE"
fi

if [ ! -f "$VAE_FILE" ]; then
    echo "Downloading Flux VAE (~300MB)..."
    # Note: ComfyUI usually expects the name flux_ae.safetensors or diffusion_pytorch_model.safetensors 
    # but the loader widget might look for specific ones.
    curl -L "$VAE_URL" -o "$VAE_FILE"
fi

echo "Setup complete!"
