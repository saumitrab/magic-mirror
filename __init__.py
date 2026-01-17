from .nodes_camera import NODE_CLASS_MAPPINGS as camera_nodes
from .nodes_camera import NODE_DISPLAY_NAME_MAPPINGS as camera_display

NODE_CLASS_MAPPINGS = {**camera_nodes}
NODE_DISPLAY_NAME_MAPPINGS = {**camera_display}

__all__ = ["NODE_CLASS_MAPPINGS", "NODE_DISPLAY_NAME_MAPPINGS"]
