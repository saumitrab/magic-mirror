import cv2
import torch
import numpy as np

class MagicWebcam:
    """
    A ComfyUI node to capture images from a webcam.
    """
    @classmethod
    def INPUT_TYPES(s):
        return {
            "required": {
                "camera_id": ("INT", {"default": 0, "min": 0, "max": 10, "step": 1}),
                "capture_button": ("BOOLEAN", {"default": True}),
            },
        }

    RETURN_TYPES = ("IMAGE",)
    FUNCTION = "capture"
    CATEGORY = "Magic Mirror"

    def capture(self, camera_id, capture_button):
        # Open the webcam
        cap = cv2.VideoCapture(camera_id)
        
        if not cap.isOpened():
            print(f"Error: Magic Mirror could not open camera {camera_id}")
            # Fallback: Blank black tensor 512x512
            black_image = np.zeros((512, 512, 3), dtype=np.float32)
            # Standard ComfyUI format: [1, H, W, 3]
            return (torch.from_numpy(black_image).unsqueeze(0),)

        try:
            # Capture frame
            ret, frame = cap.read()
            
            if not ret or frame is None:
                print(f"Error: Magic Mirror could not read from camera {camera_id}")
                black_image = np.zeros((512, 512, 3), dtype=np.float32)
                return (torch.from_numpy(black_image).unsqueeze(0),)

            # OpenCV is BGR, convert to RGB
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            
            # Normalize to 0-1 and convert to float32
            frame = frame.astype(np.float32) / 255.0
            
            # Convert to Torch Tensor [1, H, W, 3]
            image_tensor = torch.from_numpy(frame).unsqueeze(0)
            
            return (image_tensor,)
            
        finally:
            # Release the camera properly
            cap.release()

# Node mapping for ComfyUI
NODE_CLASS_MAPPINGS = {
    "MagicWebcam": MagicWebcam
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "MagicWebcam": "Magic Webcam 📸"
}
