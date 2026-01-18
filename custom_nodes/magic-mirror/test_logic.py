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
        self.assertIn("Friendly Pirate", characters)
        self.assertIn("on a Rainbow Moon", places)

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
        
        mock_cap.read.return_value = (True, fake_frame)
        
        # Run node
        node = MagicWebcam()
        result = node.capture(camera_id=0, capture_button=True)
        
        # Verify result shape [1, 100, 100, 3] and status
        self.assertIsInstance(result, tuple)
        self.assertEqual(len(result), 2)
        tensor = result[0]
        status = result[1]
        self.assertEqual(tensor.shape, (1, 100, 100, 3))
        self.assertIn("Captured", status)
        
    @patch('cv2.VideoCapture')
    def test_webcam_error_handling(self, mock_vc):
        """Tests MagicWebcam error handling returns black tensor and error status."""
        # Setup mock to fail
        mock_cap = MagicMock()
        mock_vc.return_value = mock_cap
        mock_cap.isOpened.return_value = False
        
        # Run node
        node = MagicWebcam()
        result = node.capture(camera_id=0, capture_button=True)
        
        # Verify black fallback and error status
        tensor = result[0]
        status = result[1]
        self.assertEqual(tensor.shape, (1, 512, 512, 3))
        self.assertIn("Error", status)

    def test_prompt_builder_node(self):
        """Tests MagicPromptBuilder formatted output and negative prompt."""
        node = MagicPromptBuilder()
        result = node.build(character="Lego Buddy", place="on a Rainbow Moon")
        prompt = result[0]
        negative = result[1]
        self.assertIn("Lego Buddy", prompt)
        self.assertIn("Pixar-inspired", prompt)
        self.assertIn("scary", negative)

    def test_prompt_editor(self):
        """Tests MagicPromptEditor passthrough and override."""
        from nodes_logic import MagicPromptEditor
        node = MagicPromptEditor()
        # Passthrough
        self.assertEqual(node.edit("Original", "")[0], "Original")
        # Override
        self.assertEqual(node.edit("Original", "Custom")[0], "Custom")

    def test_selectors(self):
        """Tests that selectors return the input value."""
        char_node = MagicCharacterSelector()
        place_node = MagicPlaceSelector()
        self.assertEqual(char_node.select("Pirate")[0], "Pirate")
        self.assertEqual(place_node.select("in a Jungle")[0], "in a Jungle")

if __name__ == "__main__":
    unittest.main()
