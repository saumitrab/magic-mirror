import unittest
from config import load_config, get_magic_lists

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

if __name__ == "__main__":
    unittest.main()
