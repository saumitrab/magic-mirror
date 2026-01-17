#!/bin/bash

# Navigate to the directory where this script is located
cd "$(dirname "$0")"

# Navigate to the ComfyUI root directory
# Based on the current structure: /Users/saumitrabhanage/Desktop/dev/Shreenay Projects/magic-mirror
# ComfyUI is expected at: /Users/saumitrabhanage/Desktop/dev/ComfyUI
cd "../../ComfyUI"

echo "--- Magic Mirror Launcher ---"
echo "Starting ComfyUI..."

# Activate the virtual environment
if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
else
    echo "Warning: venv/bin/activate not found. Attempting to run with system python."
fi

# Launch the browser in the background after a 5 second delay
(sleep 5; open http://127.0.0.1:8188) &

# Run ComfyUI with the optimized flags for Magic Mirror
python main.py --force-fp16 --preview-method auto
