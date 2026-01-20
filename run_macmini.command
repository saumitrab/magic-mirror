#!/bin/bash

# Magic Mirror Launcher for Mac Mini (32GB RAM)
# Optimized for Flux Schnell - High Quality Generation

# Change to script directory
cd "$(dirname "$0")"

echo "🪄 Starting Magic Mirror (Mac Mini - High Performance Mode)"
echo ""

# Check if setup was run
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found. Please run setup_macmini.sh first!"
    exit 1
fi

if [ ! -f "models/unet/flux1-schnell-Q4_0.gguf" ]; then
    echo "❌ Flux models not found. Please run setup_macmini.sh first!"
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

# Set environment variables for optimal performance on Mac Mini
export PYTORCH_ENABLE_MPS_FALLBACK=1
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0

echo "✨ Configuration:"
echo "   - Memory: High (32GB optimized)"
echo "   - Model: Flux Schnell Q4"
echo "   - Recommended Workflow: shreenay_workflow_macmini.json"
echo ""
echo "📝 Available workflows:"
echo "   - shreenay_workflow_macmini.json (recommended - Flux optimized)"
echo "   - shreenay_workflow_flux_schnell.json (same as above)"
echo ""
echo "🎨 Starting ComfyUI..."
echo "   Open http://127.0.0.1:8188 and load your workflow"
echo ""

# Launch ComfyUI with high performance settings
# --highvram: Use more RAM for faster generation
# --preview-method auto: Show generation progress
python main.py \
    --highvram \
    --preview-method auto \
    --listen 127.0.0.1 \
    --port 8188

echo ""
echo "👋 Magic Mirror stopped."
