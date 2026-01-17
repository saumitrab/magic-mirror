import unittest
import sys
from unittest.mock import MagicMock, patch

# Mock ComfyUI 'nodes' module before importing nodes_logic
sys.modules['nodes'] = MagicMock()

from config import load_config, get_magic_lists
import numpy as np
import torch
from nodes_camera import MagicWebcam
# Avoid relative import issues in standalone test
import nodes_logic
from nodes_logic import MagicPromptBuilder, MagicCharacterSelector, MagicPlaceSelector

def build_prompt(character, place):
    """Hypothetical prompt builder function."""
    return f"A {character} {place}, oil painting style"

class TestMagicMirrorLogic(unittest.TestCase):
    def test_config_loading(self):
        """Verifies the config loads correctly."""
        characters, places = get_magic_lists()
        self.assertIsInstance(characters, list)
        self.assertIsInstance(places, list)
        self.assertIn("Pirate", characters)
        self.assertIn("on the Moon", places)

    def test_prompt_builder(self):
        """Tests a hypothetical prompt builder function."""
        prompt = build_prompt("Pirate", "on the Moon")
        self.assertIn("Pirate", prompt)
        self.assertIn("on the Moon", prompt)

    @patch('cv2.VideoCapture')
    def test_webcam_node_logic(self, mock_vc):
        """Tests MagicWebcam tensor shape logic without opening a real camera."""
        # Setup mock
        mock_cap = MagicMock()
        mock_vc.return_value = mock_cap
        mock_cap.isOpened.return_value = True
        
        # Create a fake BGR frame (100x100x3)
        fake_frame = np.zeros((100, 100, 3), dtype=np.uint8)
        fake_frame[0, 0] = [255, 0, 0] # Blue in BGR
        
        mock_cap.read.return_value = (True, fake_frame)
        
        # Run node
        node = MagicWebcam()
        result = node.capture(camera_id=0, capture_button=True)
        
        # Verify result shape [1, 100, 100, 3]
        self.assertIsInstance(result, tuple)
        tensor = result[0]
        self.assertEqual(tensor.shape, (1, 100, 100, 3))
        self.assertEqual(tensor.dtype, torch.float32)
        
        # Verify color conversion: Blue (255,0,0) BGR -> Red (1.0, 0, 0) RGB in tensor
        # Wait, Blue in BGR is [255, 0, 0]. In RGB it should be [0, 0, 1.0].
        self.assertAlmostEqual(tensor[0, 0, 0, 2].item(), 1.0) # Red channel in RGB at index 0? 
        # Actually ComfyUI images are [B, H, W, C] where C=0 is Red, 1 is Green, 2 is Blue.
        # BGR (255, 0, 0) -> Blue=255. RGB (0, 0, 255) -> Blue=1.0. 
        self.assertAlmostEqual(tensor[0, 0, 0, 2].item(), 1.0) 
        
    @patch('cv2.VideoCapture')
    def test_webcam_error_handling(self, mock_vc):
        """Tests MagicWebcam error handling returns black tensor."""
        # Setup mock to fail
        mock_cap = MagicMock()
        mock_vc.return_value = mock_cap
        mock_cap.isOpened.return_value = False
        
        # Run node
        node = MagicWebcam()
        result = node.capture(camera_id=0, capture_button=True)
        
        # Verify black fallback [1, 512, 512, 3]
        tensor = result[0]
        self.assertEqual(tensor.shape, (1, 512, 512, 3))
        self.assertEqual(torch.sum(tensor).item(), 0.0)

    def test_prompt_builder_node(self):
        """Tests MagicPromptBuilder formatted output."""
        node = MagicPromptBuilder()
        result = node.build(character="Lego Character", place="on the Moon")
        prompt = result[0]
        self.assertIn("Lego Character", prompt)
        self.assertIn("on the Moon", prompt)
        self.assertIn("Close up portrait", prompt)

    def test_selectors(self):
        """Tests that selectors return the input value."""
        char_node = MagicCharacterSelector()
        place_node = MagicPlaceSelector()
        self.assertEqual(char_node.select("Pirate")[0], "Pirate")
        self.assertEqual(place_node.select("in a Jungle")[0], "in a Jungle")

if __name__ == "__main__":
    unittest.main()
