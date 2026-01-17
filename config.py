import json
import os

DEFAULT_CHARACTERS = ["Pirate", "Astronaut", "Superhero", "Wizard", "Lego Character"]
DEFAULT_PLACES = ["in a Jungle", "on the Moon", "under the Ocean", "in a Cyberpunk City"]

def load_config():
    config_path = os.path.join(os.path.dirname(__file__), "magic_config.json")
    
    if not os.path.exists(config_path):
        return {
            "characters": DEFAULT_CHARACTERS,
            "places": DEFAULT_PLACES
        }
    
    try:
        with open(config_path, "r") as f:
            return json.load(f)
    except (json.JSONDecodeError, IOError):
        return {
            "characters": DEFAULT_CHARACTERS,
            "places": DEFAULT_PLACES
        }

def get_magic_lists():
    config = load_config()
    return config.get("characters", DEFAULT_CHARACTERS), config.get("places", DEFAULT_PLACES)
