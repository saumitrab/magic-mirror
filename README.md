# 🪞 Magic Mirror: Transform into Pixar Characters!

Magic Mirror is a ComfyUI-based project that transforms webcam photos into Pixar-style characters. Designed to be simple and fun for kids (optimized for 6-year-olds!).

---

## 🚀 Quick Start

### Mac Mini M4 (32GB RAM) - High Quality Mode

```bash
# 1. Setup (first time only - downloads ~15GB)
./setup_macmini.sh

# 2. Start Magic Mirror
./run_macmini.command

# 3. Open http://127.0.0.1:8188 and load:
#    shreenay_workflow_macmini_ipadapter.json (⭐ best face preservation)
#    or shreenay_workflow_macmini.json (basic)
```

### MacBook Air M3 (8GB RAM) - Fast Mode

```bash
# 1. Setup (first time only - downloads ~10GB)
./setup_macbook.sh

# 2. Start Magic Mirror
./run_macbook.command

# 3. Open http://127.0.0.1:8188 and load:
#    shreenay_workflow_macbook_air_ipadapter.json (⭐ best face preservation)
#    or shreenay_workflow_macbook_air.json (basic SDXL)
```

---

## ✨ Features

- **📸 Magic: The Eye** - Webcam capture with real-time status
- **🎭 Character Selector** - Choose your costume (Knight, Pirate, Astronaut, etc.)
- **🌍 Place Selector** - Choose your location (Castle, Space, Jungle, etc.)
- **🧠 Magic: The Brain** - Builds Pixar-style prompts with safety filters
- **🎨 Magic: The Painter** - AI transforms you into art
- **⚡ Hardware Optimized** - Separate workflows for Mac Mini (Flux) and MacBook Air (SD 1.5/SDXL)
- **✨ IP-Adapter Integration** - Excellent face preservation using direct feature injection

---

## 🎨 How It Works

1. **The Eye** captures your webcam photo
2. **Selectors** let you pick character and place
3. **The Brain** creates a magical Pixar-style prompt
4. **The Painter** transforms you using AI
5. See yourself as a Pixar character in 10-20 seconds!

---

## 📦 What Gets Installed

### Mac Mini Setup
- Flux Schnell Q4 (~7GB) - Highest quality
- Text encoders (~5GB)
- IP-Adapter support (~3GB)
- ComfyUI core and custom nodes
- **Total:** ~15GB

### MacBook Air Setup
- SDXL Turbo (~6GB) - Fast and efficient
- OR SD 1.5 (~4GB) - Most memory efficient
- IP-Adapter support (~2GB)
- ComfyUI core and custom nodes
- **Total:** ~6-10GB

---

## 🎮 Using Magic Mirror

### Loading the Workflow

1. Open browser to http://127.0.0.1:8188
2. Load the recommended workflow:
   - **Mac Mini:** `shreenay_workflow_macmini_ipadapter.json` ⭐ (best)
   - **MacBook Air:** `shreenay_workflow_macbook_air_ipadapter.json` ⭐ (best)

### Generating Your Portrait

1. **Grant camera permissions** when prompted
2. Select a **character** from the dropdown (e.g., "Brave Medieval Knight")
3. Select a **place** from the dropdown (e.g., "in a Magical Castle")
4. Click **"Queue Prompt"**
5. Wait 10-20 seconds
6. See yourself transformed!

---

## 🛠️ Available Workflows

### IP-Adapter Workflows (⭐ Best - Excellent Face Preservation)

- **`shreenay_workflow_macmini_ipadapter.json`** ⭐⭐ - Flux + IP-Adapter (Mac Mini)
  - Highest quality + best face preservation
  - 4 steps, ~10-15 seconds
  - Uses direct facial feature injection

- **`shreenay_workflow_macbook_air_ipadapter.json`** ⭐⭐ - SD 1.5 + IP-Adapter (MacBook Air)
  - Great quality + excellent face preservation
  - 20 steps, ~20-30 seconds
  - Face-specific IP-Adapter model

### Basic Workflows (Text-Only Face Preservation)

- **`shreenay_workflow_macmini.json`** - Flux Schnell (Mac Mini, basic)
  - 4 steps, ~10-15 seconds

- **`shreenay_workflow_macbook_air.json`** - SDXL Turbo (MacBook Air, basic)
  - 2 steps, ~15-20 seconds

### Alternative Workflows

- **`shreenay_workflow_sd15.json`** - SD 1.5 (most memory efficient, no IP-Adapter)
- **`shreenay_workflow_flux_schnell.json`** - Flux (alternative Mac Mini)
- **`shreenay_workflow.json`** - SDXL (original)

---

## 🔧 Custom Nodes

All nodes are in the **"Magic Mirror"** category in ComfyUI:

- **Magic: The Eye 📸** (MagicWebcam) - Camera capture
- **Magic: Character Selector 🎭** - Choose costume
- **Magic: Place Selector 🌍** - Choose location
- **Magic: The Brain 🧠** (MagicPromptBuilder) - Creates prompts
- **Magic: Prompt Editor ✍️** - Edit prompts manually
- **Magic: The Painter 🎨** (MagicPainterWrapper) - Standard painter for SDXL/SD 1.5
- **Magic: The Flux Painter ✨** (MagicPainterFlux) - Flux-optimized painter

---

## 🐛 Troubleshooting

### "Out of Memory" Error

**MacBook Air:**
- Make sure you're using `run_macbook.command` (has --lowvram)
- Try `shreenay_workflow_sd15.json` (most efficient)
- Close other applications

**Mac Mini:**
- Restart ComfyUI
- Check Activity Monitor for memory leaks

### Models Not Found

```bash
# Check model file sizes (should be > 1MB)
ls -lh models/unet/
ls -lh models/clip/
ls -lh models/vae/

# Re-run setup if corrupted
./setup_macmini.sh  # or setup_macbook.sh
```

### Webcam Not Working

1. **Grant Camera Permissions:**
   - System Settings > Privacy & Security > Camera
   - Enable for Terminal/your launcher app

2. **Try Different Camera ID:**
   - In MagicWebcam node, change camera_id from 0 to 1

3. **Check Camera Availability:**
   ```bash
   source venv/bin/activate
   python diagnostic_camera.py
   ```

### Slow Generation

**MacBook Air:**
- Use SDXL Turbo workflow (2 steps)
- Or SD 1.5 workflow with lower steps (10-15)

**Mac Mini:**
- Flux should be fast (4 steps)
- Close other memory-heavy apps

---

## 📁 File Structure

```
magic-mirror/
├── shreenay_workflow_macmini.json        # ⭐ Mac Mini optimized
├── shreenay_workflow_macbook_air.json    # ⭐ MacBook Air optimized
├── setup_macmini.sh                      # Mac Mini setup
├── setup_macbook.sh                      # MacBook Air setup
├── run_macmini.command                   # Mac Mini launcher
├── run_macbook.command                   # MacBook Air launcher
├── SETUP_GUIDE.md                        # Detailed documentation
├── IMPLEMENTATION_SUMMARY.md             # Technical details
└── custom_nodes/magic-mirror/            # Custom nodes
    ├── nodes_camera.py                   # Webcam node
    ├── nodes_logic.py                    # Brain, Painters, Selectors
    └── config.py                         # Characters & Places
```

---

## 🎨 Customization

### Adding Characters or Places

Edit `custom_nodes/magic-mirror/config.py`:

```python
CHARACTERS = [
    "Brave Medieval Knight",
    "Space Explorer",
    "Your New Character Here",  # Add here!
]

PLACES = [
    "in a Magical Castle",
    "on Mars",
    "Your New Place Here",  # Add here!
]
```

Restart ComfyUI to see changes.

---

## 📚 Documentation

- **SETUP_GUIDE.md** - Complete setup and usage guide
- **IMPLEMENTATION_SUMMARY.md** - Technical implementation details

---

## 🔮 Next Steps (Coming Soon)

- **IP-Adapter Integration** - Better face preservation
- **Model Warm-up** - Faster first generation
- **Progress Indicators** - Kid-friendly status messages
- **Image Gallery** - See all your transformations

---

## 🧠 Technical Details

### Mac Mini Configuration
- **Model:** Flux Schnell Q4 GGUF
- **Memory:** --highvram (optimized for 32GB)
- **Settings:** 4 steps, guidance 3.5, euler sampler
- **Quality:** Highest - Best Pixar-style results

### MacBook Air Configuration
- **Model:** SDXL Turbo
- **Memory:** --lowvram --disable-smart-memory (optimized for 8GB)
- **Settings:** 2 steps, guidance 1.0, euler sampler
- **Quality:** Good - Fast and memory efficient

### Memory Management
- `PYTORCH_ENABLE_MPS_FALLBACK=1` - Metal Performance Shaders fallback
- `PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0` - Prevents memory crashes

---

## 🧪 Testing

Run unit tests:
```bash
python3 -m unittest test_logic.py
```

---

## 📄 License & Credits

- **ComfyUI** - Core diffusion UI framework
- **Flux Schnell** - Black Forest Labs
- **IP-Adapter** - Tencent ARC
- **Magic Mirror Custom Nodes** - Original implementation

---

*Made with ❤️ for Shreenay*
