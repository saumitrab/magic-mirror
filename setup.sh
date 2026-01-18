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

# 3. Install Requirements
echo "Installing dependencies..."
source venv/bin/activate
pip install --upgrade pip
# Install ComfyUI requirements
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi
# Install Magic Mirror specific requirements
if [ -f "custom_nodes/magic-mirror/requirements.txt" ]; then
    pip install -r custom_nodes/magic-mirror/requirements.txt
else
    pip install opencv-python torch numpy torchvision
fi

echo "Setup complete!"
