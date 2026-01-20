# Magic Mirror Setup Guide

Transform webcam photos into Pixar-style characters with AI magic!

---

## Hardware Requirements

### Mac Mini M4 (32GB RAM) - Recommended
- **Model:** Flux Schnell Q4
- **Quality:** High (1024x1024)
- **Generation Time:** 10-15 seconds
- **Memory Usage:** ~12-16GB

### MacBook Air M3 (8GB RAM) - Lightweight
- **Model:** SD 1.5 or SDXL Turbo
- **Quality:** Medium (512x512 - 1024x1024)
- **Generation Time:** 15-30 seconds
- **Memory Usage:** ~6-8GB

---

## Quick Start

### For Mac Mini (32GB)

```bash
# 1. Run setup (downloads Flux models + IP-Adapter, ~12GB total)
./setup_macmini.sh

# 2. Start Magic Mirror
./run_macmini.command
```

### For MacBook Air (8GB)

```bash
# 1. Run setup (downloads SD 1.5 models, ~6GB total)
./setup_macbook.sh

# 2. Start Magic Mirror
./run_macbook.command
```

---

## What Gets Installed

### Mac Mini Setup (`setup_macmini.sh`)
- ✅ ComfyUI core
- ✅ Flux Schnell Q4 UNET (~7GB)
- ✅ T5 Text Encoder (~4.5GB)
- ✅ CLIP-L (~200MB)
- ✅ Flux VAE (~300MB)
- ✅ IP-Adapter Plus (SDXL/Flux compatible) (~1GB)
- ✅ CLIP Vision Encoder (~2GB)
- ✅ ComfyUI IP-Adapter nodes

**Total:** ~15GB

### MacBook Air Setup (`setup_macbook.sh`)
- ✅ ComfyUI core
- ✅ Realistic Vision v5.1 (SD 1.5) (~4GB)
- ✅ IP-Adapter Face (SD 1.5) (~100MB)
- ✅ CLIP Vision Encoder (~2GB)
- ✅ ComfyUI IP-Adapter nodes

**Total:** ~6GB

---

## Using Magic Mirror

1. Open browser to http://127.0.0.1:8188
2. Load workflow:
   - **Mac Mini:** `shreenay_workflow_macmini_ipadapter.json` ⭐ (best face preservation)
   - **Mac Mini:** `shreenay_workflow_macmini.json` (basic)
   - **MacBook Air:** `shreenay_workflow_macbook_air_ipadapter.json` ⭐ (best face preservation)
   - **MacBook Air:** `shreenay_workflow_macbook_air.json` (basic SDXL)
3. Select character and place from dropdowns
4. Click "Queue Prompt" to generate

### What is IP-Adapter? (⭐ Workflows)

The **IP-Adapter workflows** provide significantly better face preservation:

**Without IP-Adapter (basic workflows):**
- Relies on text prompts like "preserve exact facial features"
- Face resemblance is hit-or-miss
- Results vary widely

**With IP-Adapter (⭐ workflows):**
- Extracts facial features directly from your webcam photo
- Injects those features into the AI generation process
- **Much more reliable face preservation!**

The IP-Adapter models were downloaded during setup and are ready to use. Just load the `_ipadapter` workflow version!

### Custom Nodes (Kid-Friendly Names)
- 🎭 **Character Selector** - Choose costume
- 🌍 **Place Selector** - Choose location
- 🧠 **The Brain** - Creates magic description
- 📸 **The Eye** (MagicWebcam) - Captures photo
- 🎨 **The Painter** - Transforms into art

---

## Workflows

### IP-Adapter Workflows (⭐ Best Face Preservation)

#### `shreenay_workflow_macmini_ipadapter.json` ⭐⭐ Mac Mini (BEST)
- **Model:** Flux Schnell Q4 + IP-Adapter Plus (SDXL)
- **Settings:** 4 steps, guidance 3.5, IP-Adapter weight 1.0
- **Face Preservation:** Excellent! Uses direct feature injection
- **Strengths:**
  - Best quality Pixar-style output
  - **Much better face resemblance than text-only**
  - Fast generation (10-15 seconds)
- **Requirements:** 32GB RAM, Mac Mini M4
- **Generation Time:** ~10-15 seconds
- **Extra Nodes:** IPAdapterModelLoader, CLIPVisionLoader, IPAdapterApply

#### `shreenay_workflow_macbook_air_ipadapter.json` ⭐⭐ MacBook Air (BEST)
- **Model:** SD 1.5 (Realistic Vision) + IP-Adapter Plus Face
- **Settings:** 20 steps, guidance 7.0, IP-Adapter weight 1.0
- **Face Preservation:** Excellent! Face-specific IP-Adapter
- **Strengths:**
  - **Much better face resemblance than text-only**
  - Memory efficient (fits in 8GB)
  - Reliable generation
- **Requirements:** 8GB RAM minimum
- **Generation Time:** ~20-30 seconds
- **Extra Nodes:** IPAdapterModelLoader, CLIPVisionLoader, IPAdapterApply

### Basic Workflows (No IP-Adapter)

#### `shreenay_workflow_macmini.json` - Mac Mini (Basic)
- **Model:** Flux Schnell Q4
- **Settings:** 4 steps, guidance 3.5
- **Face Preservation:** Text-only (less reliable)
- **Use when:** Testing or troubleshooting
- **Generation Time:** ~10-15 seconds

#### `shreenay_workflow_macbook_air.json` - MacBook Air (Basic)
- **Model:** SDXL Turbo
- **Settings:** 2 steps, guidance 1.0
- **Face Preservation:** Text-only (less reliable)
- **Use when:** Quick tests or if IP-Adapter has issues
- **Generation Time:** ~15-20 seconds

### Alternative Workflows

#### `shreenay_workflow_flux_schnell.json` (Mac Mini Alternative)
- Same as `shreenay_workflow_macmini.json`
- Kept for compatibility

#### `shreenay_workflow_sd15.json` (MacBook Air - Most Efficient)
- **Model:** Realistic Vision v5.1 (SD 1.5)
- **Settings:** 20 steps, guidance 7.0
- **Best for:** Maximum memory efficiency on 8GB systems
- **Tradeoff:** Lower resolution (512x512 native), slightly lower quality

#### `shreenay_workflow.json` (SDXL - Original)
- **Model:** SDXL Turbo
- **Similar to:** MacBook Air workflow
- **Note:** Works on both systems with appropriate memory flags

---

## Adjusting IP-Adapter Settings

If you're using the IP-Adapter workflows, you can fine-tune face preservation:

### IP-Adapter Weight (in IPAdapterApply node)
- **Default:** 1.0
- **Range:** 0.0 - 1.5
- **Lower (0.5-0.8):** Less face preservation, more creative freedom
- **Higher (1.0-1.3):** Stronger face preservation, more faithful to photo
- **Too high (>1.3):** May look unnatural or "pasted on"

**How to adjust:**
1. Open the IPAdapterApply node in ComfyUI
2. Find the "weight" parameter (first number)
3. Change from 1.0 to your desired value
4. Queue prompt again

### When to Adjust

**Face not recognizable?** Increase weight to 1.2-1.3
**Face looks too "pasted on"?** Decrease weight to 0.7-0.8
**Want more artistic freedom?** Decrease weight to 0.5-0.6

---

## Troubleshooting

### "Out of Memory" Error
**MacBook Air:**
- Make sure you're using `run_macbook.command` (has --lowvram flag)
- Try SD 1.5 workflow instead of SDXL
- Close other applications

**Mac Mini:**
- Restart ComfyUI
- Check Activity Monitor for memory leaks

### "Model Not Found" Error
- Run the appropriate setup script for your hardware
- Check `models/` directory to verify downloads completed
- Re-run setup if files are corrupted (< 1MB size)

### Slow Generation
**MacBook Air:**
- Lower steps to 10-15 (current: 20)
- Use SD 1.5 instead of SDXL
- Reduce image resolution

**Mac Mini:**
- Flux Schnell should be fast (4-6 steps)
- Check if other apps are using memory

### Webcam Not Working
- Grant camera permissions: System Settings > Privacy & Security > Camera
- Try a different camera index (change widget value from 0 to 1)
- Check camera is not in use by another app

### Models Download Failed
The setup script now verifies downloads. If you see:
- ❌ "Downloaded file is HTML" - URL may be gated or moved
- ❌ "Downloaded file too small" - Network issue, try again
- ⚠️ "Removing corrupted file" - Previous download failed, will retry

Common fixes:
```bash
# Remove corrupted models manually
rm models/clip/clip_l.safetensors
rm models/vae/ae.safetensors

# Re-run setup
./setup_macmini.sh  # or setup_macbook.sh
```

---

## Next Steps: Face Preservation

Currently, face preservation relies on text prompts. For better face preservation:

### Phase 2 (Planned): IP-Adapter Integration
IP-Adapter models are downloaded but not yet integrated into workflows.

**To enable IP-Adapter:**
1. ComfyUI IP-Adapter nodes are already installed
2. Add IP-Adapter nodes to workflow:
   - `IPAdapterModelLoader` - loads IP-Adapter model
   - `CLIPVisionLoader` - loads vision encoder
   - `IPAdapterApply` - applies face embedding
3. Connect webcam image to both VAE encoder AND IP-Adapter
4. Adjust prompt to reduce emphasis on "preserve face" text

**Expected Improvement:**
- Mac Mini (Flux): Good → Excellent face preservation
- MacBook Air (SD 1.5): Medium → Excellent face preservation

---

## Advanced: Memory Optimization

### Mac Mini Flags (`run_macmini.command`)
```bash
--highvram              # Use more RAM for faster generation
--preview-method auto   # Show progress during generation
```

### MacBook Air Flags (`run_macbook.command`)
```bash
--lowvram               # Aggressive memory management
--disable-smart-memory  # Disable smart memory (helps on 8GB)
--preview-method auto   # Show progress
```

### Custom Flags
Edit the launcher scripts to add:
- `--cpu` - Force CPU mode (very slow, emergency fallback)
- `--fp16-vae` - Use FP16 VAE (saves ~200MB)
- `--dont-upcast-attention` - Saves memory, may affect quality

---

## File Structure

```
magic-mirror/
├── setup.sh                                       # Base setup (Flux models)
├── setup_macmini.sh                               # Mac Mini setup (adds IP-Adapter)
├── setup_macbook.sh                               # MacBook Air setup (SD 1.5 + IP-Adapter)
├── run_macmini.command                            # Mac Mini launcher (--highvram)
├── run_macbook.command                            # MacBook Air launcher (--lowvram)
├── shreenay_workflow_macmini_ipadapter.json       # ⭐⭐ Mac Mini (Flux + IP-Adapter)
├── shreenay_workflow_macbook_air_ipadapter.json   # ⭐⭐ MacBook Air (SD 1.5 + IP-Adapter)
├── shreenay_workflow_macmini.json                 # Mac Mini basic (Flux only)
├── shreenay_workflow_macbook_air.json             # MacBook Air basic (SDXL Turbo)
├── shreenay_workflow_flux_schnell.json            # Flux workflow (alternative)
├── shreenay_workflow_sd15.json                    # SD 1.5 workflow (no IP-Adapter)
├── shreenay_workflow.json                         # SDXL workflow (original)
├── SETUP_GUIDE.md                                 # This guide
├── IMPLEMENTATION_SUMMARY.md                      # Developer documentation
├── custom_nodes/
│   ├── magic-mirror/
│   │   ├── nodes_camera.py                        # MagicWebcam
│   │   ├── nodes_logic.py                         # Brain, Painters, Selectors
│   │   └── config.py                              # Character/Place lists
│   └── ComfyUI_IPAdapter_plus/                    # IP-Adapter nodes (installed)
├── models/
│   ├── unet/                                      # Flux UNET
│   ├── clip/                                      # Text encoders
│   ├── vae/                                       # VAE
│   ├── checkpoints/                               # SD 1.5/SDXL checkpoints
│   ├── ipadapter/                                 # IP-Adapter models ⭐
│   │   ├── ip-adapter-plus_sdxl_vit-h.safetensors # For Mac Mini (Flux/SDXL)
│   │   └── ip-adapter-plus-face_sd15.bin          # For MacBook Air (SD 1.5)
│   └── clip_vision/                               # CLIP Vision encoders
│       └── CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors
└── venv/                                          # Python virtual environment
```

---

## For Developers

### Custom Nodes

#### `MagicPainterWrapper` (SDXL/SD 1.5)
- Standard KSampler wrapper
- Uses negative prompts
- Works with SDXL Turbo and SD 1.5

#### `MagicPainterFlux` (Flux Schnell)
- Flux-specific painter
- Applies ModelSamplingFlux for proper guidance
- No negative prompts (Flux ignores them)
- Optimized for Flux Schnell

### Adding Characters/Places
Edit `custom_nodes/magic-mirror/config.py`:

```python
CHARACTERS = [
    "Brave Medieval Knight",
    "Space Explorer",
    # Add your character here
]

PLACES = [
    "in a Magical Castle",
    "on Mars",
    # Add your place here
]
```

### Testing Both Systems
You can run either setup on either machine:
- Run MacBook Air setup on Mac Mini for testing lightweight mode
- Both workflows will load in ComfyUI

---

## Credits

- **ComfyUI** - Core diffusion UI
- **Flux Schnell** - Black Forest Labs
- **IP-Adapter** - Tencent ARC
- **Magic Mirror** - Custom nodes for kid-friendly UI

---

## Support

For issues:
1. Check Troubleshooting section above
2. Verify setup completed without errors
3. Check ComfyUI console for error messages
4. Try the fallback workflow for your hardware
