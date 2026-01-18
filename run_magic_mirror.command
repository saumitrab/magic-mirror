#!/bin/bash
# Navigate to the directory where this script is located
PROJECT_DIR="$(dirname "$0")"
cd "$PROJECT_DIR"

# Required for macOS to prevent OpenCV from crashing when requesting camera permissions from a background thread
export OPENCV_AVFOUNDATION_SKIP_AUTH=1

echo "--- Magic Mirror Launcher ---"

# 1. Automatic Setup Check
if [ ! -f "main.py" ] || [ ! -d "venv" ]; then
    echo "First time setup detected..."
    bash setup.sh
fi

# 2. Start ComfyUI
echo "Starting ComfyUI..."
source venv/bin/activate

# Launch the browser in the background after a 5 second delay
(sleep 5; open http://127.0.0.1:8188) &

# Run ComfyUI with the optimized flags for Magic Mirror
python main.py --force-fp16 --preview-method auto
