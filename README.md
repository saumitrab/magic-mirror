# 🪞 Magic Mirror: Educational ComfyUI Node Pack

Magic Mirror is a collection of custom ComfyUI nodes designed to be simple, interactive, and fun for children (specifically optimized for a 6-year-old!). It allows users to capture their image via webcam and transform themselves into various characters and places using AI.

## ✨ Features

- **📸 Magic: The Eye**: A robust webcam capture node with real-time status feedback.
- **🧠 Magic: The Brain**: A Pixar-style prompt builder that ensures kid-friendly results with built-in safety filters.
- **✍️ Magic: Prompt Editor**: A new node that lets you see and manually edit the prompt before painting.
- **🎨 Magic: The Painter**: Now includes negative-prompt support to keep results clean and fun.
- **🎭 Customizable**: Characters and places are easily editable via a JSON configuration file.
- **🚀 One-Click Launcher**: Includes a macOS `.command` script to start everything with one click (including automatic model downloads!).

> [!IMPORTANT]
> **Flux Schnell Upgrade**: This version uses Flux.1 Schnell GGUF, optimized for MacBook Air memory (16-24GB RAM).
> 1. Close all other apps (browsers, Slack, etc.) to free up Unified Memory.
> 2. The first capture may take 1-5 minutes as the model loads into RAM.

## 🛠️ How It Works

Magic Mirror abstracts the complex parts of AI workflows into friendly, labeled components:

1.  **The Input (The Eye)**: Captures a live frame from your webcam.
2.  **The Logic (The Brain)**: You select a **Character** (e.g., Pirate, Astronaut) and a **Place** (e.g., on the Moon). The "Brain" builds a cinematic prompt like: *"Close up portrait of a Pirate on the Moon, cinematic lighting..."*
3.  **The Creation (The Painter)**: The Painter takes your webcam photo and the Brain's prompt, then "paints" your transformation using **Flux.1 Schnell**, a high-quality model designed for few-step generation on local hardware.

## 🚀 Getting Started

### Installation on a New Machine

1.  Clone this repository:
    ```bash
    git clone <repository-url> magic-mirror
    ```
2.  Navigate into the folder:
    ```bash
    cd magic-mirror
    ```
3.  **That's it!** The launcher will handle the rest.

### Running (macOS)

Double-click `run_magic_mirror.command` in the project folder. 
- **First time**: It will automatically download the ComfyUI core, set up a virtual environment, and install all dependencies.
- **Subsequent times**: It will simply launch ComfyUI with optimized memory settings (low-vram) and open your browser.

### 📥 Required Models

To use Flux Schnell on MacBook Air, you need the following models:

1.  **UNET (GGUF)**: [flux1-schnell-Q4_0.gguf](https://huggingface.co/city96/FLUX.1-schnell-gguf/resolve/main/flux1-schnell-Q4_0.gguf)
    - Place in `models/unet/`
2.  **CLIP (GGUF/Safetensors)**: [t5-v1_1-xxl-encoder-Q3_K_M.gguf](https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/t5-v1_1-xxl-encoder-Q3_K_M.gguf) and `clip_l.safetensors`
    - Place in `models/clip/`
3.  **VAE**: `flux_ae.safetensors`
    - Place in `models/vae/`

### 🔧 Custom Nodes

Install the following custom nodes via ComfyUI Manager:
- `ComfyUI-GGUF` (for loading the quantized models)

## 🎨 How to Build the Workflow

Once the ComfyUI browser window opens, follow these steps to build your Magic Mirror:

### 1. The Power Source
Add a **Unet Loader (GGUF)** for the model and **DualCLIPLoader (GGUF)** for the CLIP/T5. Select the Flux models downloaded earlier.

### 2. Add the Magic Nodes
Right-click and find the **Magic Mirror** category. Add these nodes:
- **Magic: The Eye 📸**: Your camera (outputs image and **status**).
- **Magic: Character Selector 🎭**: Choose your costume.
- **Magic: Place Selector 🌍**: Choose your destination.
- **Magic: The Brain 🧠**: The logic center (outputs **prompt** and **negative_prompt**).
- **Magic: Prompt Editor ✍️**: (Optional) Sit here to see or change the AI's idea!
- **Magic: The Painter 🎨**: The artist.

### 3. Connect the "Noodles"
- **The Brain Logic**: 
    - Connect **Selectors** to **The Brain**.
    - Connect **The Brain's `prompt`** to the **Prompt Editor**.
    - Connect **The Brain's `negative_prompt`** directly to **The Painter**.
- **The Painter**: 
    - Connect **MODEL**, **CLIP**, and **VAE** from your Loader to **The Painter**.
    - Connect **Prompt Editor's `prompt`** to **The Painter**.
    - Connect **IMAGE** from **The Eye** to **The Painter**.
- **Visual Feedback**:
    - Add a **Preview Image** node for the final picture.
    - (Optional) Add a "Show Text" or "Display String" node (if you have one) to **The Eye's `status`** to see when a photo is taken.

### 4. Click "Queue Prompt"
Watch yourself transform into a friendly Pixar-style character! 🚀

## 🧠 Key Design Decisions

- **Flux Schnell Optimization**: Configured with 4 steps and 1.0 Guidance for the best speed/quality balance on M-series chips.
- **Memory Management**: Uses `--lowvram` and `PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0` to prevent crashes on MacBook Air.
- **Graceful Failures**: If the webcam is busy or fails, the system returns a blank black image instead of crashing.
- **Color Correction**: Automatically handles OpenCV's BGR to RGB conversion for correct colors in AI processing.
- **Mac Permissons**: Isoloated camera logic to ensure `cv2.VideoCapture` is properly released to avoid "camera already in use" errors common on macOS.

## 📹 Webcam Troubleshooting (macOS)

If you see an error like `Magic Mirror could not open camera 0` or a black image:

### 1. Grant Permissions
macOS requires explicit permission for Terminal apps to access the camera.
1.  Open your Terminal.
2.  Run the diagnostic script:
    ```bash
    source venv/bin/activate
    python diagnostic_camera.py
    ```
3.  **Watch for a macOS popup**: A dialog will appear asking for Camera access. Click **OK**.
4.  Go to **System Settings > Privacy & Security > Camera** and ensure your Terminal app is toggled **ON**.

### 2. Check Camera ID
If you have an external webcam, it might not be `ID 0`.
1.  The `diagnostic_camera.py` script will list all working IDs it finds.
2.  Update the **Magic: The Eye** node in ComfyUI with the correct `camera_id` (usually `1` for external).

### 3. Background Threading Fix
We have already added `export OPENCV_AVFOUNDATION_SKIP_AUTH=1` to the launcher to prevent OpenCV from crashing when running inside ComfyUI's background threads.

## 🧪 Testing

The project includes a suite of unit tests to ensure logic remains sound even if configuration files are modified:

```bash
python3 -m unittest test_logic.py
```

---
*Created with ❤️ for Shreenay.*
