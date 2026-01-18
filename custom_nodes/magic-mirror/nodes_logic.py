import torch
import numpy as np
import os
try:
    from .config import get_magic_lists
except ImportError:
    from config import get_magic_lists

# Import standard ComfyUI nodes to reuse their logic
import nodes

class MagicCharacterSelector:
    @classmethod
    def INPUT_TYPES(s):
        characters, _ = get_magic_lists()
        return {
            "required": {
                "character": (characters,),
            },
        }

    RETURN_TYPES = ("STRING",)
    FUNCTION = "select"
    CATEGORY = "Magic Mirror"

    def select(self, character):
        return (character,)

class MagicPlaceSelector:
    @classmethod
    def INPUT_TYPES(s):
        _, places = get_magic_lists()
        return {
            "required": {
                "place": (places,),
            },
        }

    RETURN_TYPES = ("STRING",)
    FUNCTION = "select"
    CATEGORY = "Magic Mirror"

    def select(self, place):
        return (place,)

class MagicPromptBuilder:
    @classmethod
    def INPUT_TYPES(s):
        return {
            "required": {
                "character": ("STRING", {"forceInput": True}),
                "place": ("STRING", {"forceInput": True}),
            },
        }

    RETURN_TYPES = ("STRING",)
    FUNCTION = "build"
    CATEGORY = "Magic Mirror"

    def build(self, character, place):
        prompt = f"Close up portrait of a {character} {place}, cinematic lighting, detailed, 8k, photorealistic."
        print(f"--- Magic Mirror Brain ---\nGenerated Prompt: {prompt}\n--------------------------")
        return (prompt,)

class MagicPainterWrapper:
    @classmethod
    def INPUT_TYPES(s):
        return {
            "required": {
                "model": ("MODEL",),
                "vae": ("VAE",),
                "clip": ("CLIP",),
                "image": ("IMAGE",),
                "prompt": ("STRING", {"forceInput": True}),
                "magic_strength": ("FLOAT", {"default": 0.6, "min": 0.0, "max": 1.0, "step": 0.01}),
                "seed": ("INT", {"default": 0, "min": 0, "max": 0xffffffffffffffff}),
            },
        }

    RETURN_TYPES = ("IMAGE",)
    FUNCTION = "paint"
    CATEGORY = "Magic Mirror"

    def paint(self, model, vae, clip, image, prompt, magic_strength, seed):
        # 1. Encode Text (CLIPTextEncode)
        encoder = nodes.CLIPTextEncode()
        conditioning = encoder.encode(clip, prompt)[0]
        
        # We need a negative conditioning too, usually just empty text
        negative_conditioning = encoder.encode(clip, "")[0]

        # 2. Encode Image (VAEEncode)
        vae_encoder = nodes.VAEEncode()
        latent = vae_encoder.encode(vae, image)[0]

        # 3. Sample (KSampler Logic)
        # Using common_ksampler or KSampler node
        sampler = nodes.KSampler()
        
        # Hardcoded settings for SDXL Turbo
        steps = 2
        cfg = 1.0
        sampler_name = "euler_ancestral"
        scheduler = "normal"
        denoise = magic_strength
        
        # Execute sampling
        samples = sampler.sample(
            model, seed, steps, cfg, sampler_name, scheduler, 
            conditioning, negative_conditioning, latent, denoise=denoise
        )[0]

        # 4. Decode (VAEDecode)
        vae_decoder = nodes.VAEDecode()
        pixels = vae_decoder.decode(vae, samples)[0]

        return (pixels,)

# Node mapping for ComfyUI
NODE_CLASS_MAPPINGS = {
    "MagicCharacterSelector": MagicCharacterSelector,
    "MagicPlaceSelector": MagicPlaceSelector,
    "MagicPromptBuilder": MagicPromptBuilder,
    "MagicPainterWrapper": MagicPainterWrapper
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "MagicCharacterSelector": "Magic: Character Selector 🎭",
    "MagicPlaceSelector": "Magic: Place Selector 🌍",
    "MagicPromptBuilder": "Magic: The Brain 🧠",
    "MagicPainterWrapper": "Magic: The Painter 🎨"
}
