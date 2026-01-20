#!/bin/bash

# Magic Mirror Launcher for MacBook Air (8GB RAM)
# Optimized for SD 1.5 - Lightweight & Fast

# Change to script directory
cd "$(dirname "$0")"

echo "🪄 Starting Magic Mirror (MacBook Air - Lightweight Mode)"
echo ""

# Check if setup was run
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found. Please run setup_macbook.sh first!"
    exit 1
fi

if [ ! -f "models/checkpoints/realisticVisionV51_v51VAE.safetensors" ]; then
    echo "⚠️  SD 1.5 model not found. Please run setup_macbook.sh first!"
    echo "    Alternatively, you can run the SDXL workflow with --lowvram flag."
    echo ""
    read -p "Press Enter to continue with SDXL workflow, or Ctrl+C to exit..."
fi

# Activate virtual environment
source venv/bin/activate

# Set environment variables for memory optimization
export PYTORCH_ENABLE_MPS_FALLBACK=1
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0

echo "✨ Configuration:"
echo "   - Memory: Low (8GB optimized)"
echo "   - Model: SD 1.5 + IP-Adapter (best) or SDXL Turbo (fast)"
echo "   - Recommended Workflow: shreenay_workflow_macbook_air_ipadapter.json"
echo "   - Memory Flags: --lowvram --disable-smart-memory"
echo ""
echo "📝 Available workflows:"
echo "   - shreenay_workflow_macbook_air_ipadapter.json ⭐ (BEST - SD 1.5 + Face Preservation)"
echo "   - shreenay_workflow_macbook_air.json (basic - SDXL Turbo, faster)"
echo "   - shreenay_workflow_sd15.json (SD 1.5 - no IP-Adapter)"
echo "   - shreenay_workflow.json (SDXL - alternative)"
echo ""
echo "🎨 Starting ComfyUI..."
echo "   Open http://127.0.0.1:8188 and load your workflow"
echo ""

# Launch ComfyUI with memory-saving settings
# --lowvram: Aggressive memory management for 8GB systems
# --disable-smart-memory: Disable smart memory (can cause issues on low RAM)
# --preview-method auto: Show generation progress
python main.py \
    --lowvram \
    --disable-smart-memory \
    --preview-method auto \
    --listen 127.0.0.1 \
    --port 8188

echo ""
echo "👋 Magic Mirror stopped."
