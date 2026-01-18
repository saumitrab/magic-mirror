from .nodes_camera import NODE_CLASS_MAPPINGS as camera_nodes
from .nodes_camera import NODE_DISPLAY_NAME_MAPPINGS as camera_display
from .nodes_logic import NODE_CLASS_MAPPINGS as logic_nodes
from .nodes_logic import NODE_DISPLAY_NAME_MAPPINGS as logic_display

NODE_CLASS_MAPPINGS = {
    **camera_nodes,
    **logic_nodes
}

NODE_DISPLAY_NAME_MAPPINGS = {
    **camera_display,
    **logic_display
}

# Override camera display name as requested
NODE_DISPLAY_NAME_MAPPINGS["MagicWebcam"] = "Magic: The Eye 📸"

__all__ = ["NODE_CLASS_MAPPINGS", "NODE_DISPLAY_NAME_MAPPINGS"]
