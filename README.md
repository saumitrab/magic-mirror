# 🪞 Magic Mirror: Educational ComfyUI Node Pack

Magic Mirror is a collection of custom ComfyUI nodes designed to be simple, interactive, and fun for children (specifically optimized for a 6-year-old!). It allows users to capture their image via webcam and transform themselves into various characters and places using AI.

## ✨ Features

- **📸 Magic: The Eye**: A robust webcam capture node optimized for macOS.
- **🧠 Magic: The Brain**: A simplified prompt builder that combines character and place selections into high-quality AI prompts.
- **🎨 Magic: The Painter**: A "complexity hider" wrapper around SDXL Turbo sampling. It handles all the technical settings (steps, CFG, etc.) behind the scenes.
- **🎭 Customizable**: Characters and places are easily editable via a JSON configuration file.
- **🚀 One-Click Launcher**: Includes a macOS `.command` script to start everything with one click (including automatic model downloads!).

> [!NOTE]
> **First Run**: The first time you run the project, it will download the SDXL Turbo model (~7GB). Please ensure you have a stable internet connection.

## 🛠️ How It Works

Magic Mirror abstracts the complex parts of AI workflows into friendly, labeled components:

1.  **The Input (The Eye)**: Captures a live frame from your webcam.
2.  **The Logic (The Brain)**: You select a **Character** (e.g., Pirate, Astronaut) and a **Place** (e.g., on the Moon). The "Brain" builds a cinematic prompt like: *"Close up portrait of a Pirate on the Moon, cinematic lighting..."*
3.  **The Creation (The Painter)**: The Painter takes your webcam photo and the Brain's prompt, then "paints" your transformation using a high-speed AI model (SDXL Turbo).

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
- **Subsequent times**: It will simply launch ComfyUI with optimized settings and open your browser.

## 🎨 How to Build the Workflow

Once the ComfyUI browser window opens, follow these steps to build your Magic Mirror:

### 1. The Power Source
Add a **CheckpointLoaderSimple** (`Add Node > loaders`) and select the `sd_xl_turbo` model.

### 2. Add the Magic Nodes
Right-click and find the **Magic Mirror** category. Add these nodes:
- **Magic: The Eye 📸**: Your camera.
- **Magic: Character Selector 🎭**: Choose your costume.
- **Magic: Place Selector 🌍**: Choose your destination.
- **Magic: The Brain 🧠**: The logic center.
- **Magic: The Painter 🎨**: The artist.

### 3. Connect the "Noodles"
- **The Logic**: Connect Selector outputs to **The Brain** inputs.
- **The Painter**: Connect **MODEL**, **CLIP**, and **VAE** from your Loader to **The Painter**.
- **The Inputs**: Connect **IMAGE** from **The Eye** and **STRING** from **The Brain** to **The Painter**.
- **The Result**: Add a **Preview Image** node and connect it to **The Painter's** output.

### 4. Click "Queue Prompt"
Watch yourself transform in the preview window! 🚀

## 🧠 Key Design Decisions

- **SDXL Turbo Optimization**: Hardcoded to 2 steps and 1.0 CFG for nearly instant results, essential for keeping children engaged.
- **Graceful Failures**: If the webcam is busy or fails, the system returns a blank black image instead of crashing, with clear error messages in the console.
- **Color Correction**: Automatically handles OpenCV's BGR to RGB conversion for correct colors in AI processing.
- **Mac Permissons**: Isoloated camera logic to ensure `cv2.VideoCapture` is properly released to avoid "camera already in use" errors common on macOS.

## 🧪 Testing

The project includes a suite of unit tests to ensure logic remains sound even if configuration files are modified:

```bash
python3 -m unittest test_logic.py
```

---
*Created with ❤️ for Shreenay.*
