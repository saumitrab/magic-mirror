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

    RETURN_TYPES = ("STRING", "STRING")
    RETURN_NAMES = ("prompt", "negative_prompt")
    FUNCTION = "build"
    CATEGORY = "Magic Mirror"

    def build(self, character, place):
        prompt = (
            f"A cute happy child with the exact same face, expression, skin tone and features as the reference photo, "
            f"wearing a detailed {character} costume, standing in {place}, Pixar animation style, vibrant colors, "
            f"fun adventurous mood, perfect composition, sharp focus. "
            f"It is critical to preserve the exact facial features and expression from the reference photo."
        )
        negative_prompt = "blurry, deformed, scary, adult, dark, realistic, distorted, ugly, angry, mean, weapons, blood, gore, photorealistic"
        print(f"--- Magic Mirror Brain ---\nGenerated Prompt: {prompt}\n--------------------------")
        return (prompt, negative_prompt)

class MagicPromptEditor:
    @classmethod
    def INPUT_TYPES(s):
        return {
            "required": {
                "prompt": ("STRING", {"forceInput": True}),
                "override_text": ("STRING", {"multiline": True, "default": ""}),
            },
        }

    RETURN_TYPES = ("STRING",)
    RETURN_NAMES = ("prompt",)
    FUNCTION = "edit"
    CATEGORY = "Magic Mirror"

    def edit(self, prompt, override_text):
        final_prompt = override_text if override_text.strip() else prompt
        return (final_prompt,)

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
                "negative_prompt": ("STRING", {"forceInput": True}),
                "steps": ("INT", {"default": 4, "min": 1, "max": 50}),
                "guidance": ("FLOAT", {"default": 1.0, "min": 0.0, "max": 10.0, "step": 0.1}),
                "denoise": ("FLOAT", {"default": 0.75, "min": 0.0, "max": 1.0, "step": 0.01}),
                "seed": ("INT", {"default": 0, "min": 0, "max": 0xffffffffffffffff}),
                "sampler_name": (["euler", "heun", "dpmpp_2m", "dpmpp_sde"], {"default": "euler"}),
                "scheduler": (["simple", "normal", "beta", "karras"], {"default": "simple"}),
            },
        }

    RETURN_TYPES = ("IMAGE",)
    FUNCTION = "paint"
    CATEGORY = "Magic Mirror"

    def paint(self, model, vae, clip, image, prompt, negative_prompt, steps, guidance, denoise, seed, sampler_name, scheduler):
        # 1. Encode Text (CLIPTextEncode)
        encoder = nodes.CLIPTextEncode()
        conditioning = encoder.encode(clip, prompt)[0]
        
        # Flux often uses guidance via an extra node, but for simplicity we can 
        # try to use a Flux-capable sampler logic.
        # Many Flux implementations use ModelSamplingFlux to set guidance.
        # Here we will assume the model already has Flux guidance applied or 
        # use the provided guidance in the sampler if supported.
        
        # Use provided negative prompt
        negative_conditioning = encoder.encode(clip, negative_prompt)[0]

        # 2. Encode Image (VAEEncode)
        vae_encoder = nodes.VAEEncode()
        latent = vae_encoder.encode(vae, image)[0]

        # 3. Sample (KSampler Logic)
        # For Flux Schnell, we use lower steps and low CFG/Guidance.
        sampler = nodes.KSampler()
        
        # Execute sampling
        samples = sampler.sample(
            model, seed, steps, guidance, sampler_name, scheduler, 
            conditioning, negative_conditioning, latent, denoise=denoise
        )[0]

        # 4. Decode (VAEDecode)
        vae_decoder = nodes.VAEDecode()
        pixels = vae_decoder.decode(vae, samples)[0]

        return (pixels,)

class MagicStatusDisplay:
    @classmethod
    def INPUT_TYPES(s):
        return {
            "required": {
                "text": ("STRING", {"forceInput": True}),
            },
        }

    RETURN_TYPES = ()
    FUNCTION = "display"
    OUTPUT_NODE = True # This makes it an output node type
    CATEGORY = "Magic Mirror"

    def display(self, text):
        # We also print to terminal for debugging
        print(f"🪄 Status: {text}")
        # To show it in ComfyUI, we rely on the internal 'text' widget if present,
        # but for a simple custom node, just having it as an output node is a start.
        return {"ui": {"text": text}}

# Node mapping for ComfyUI
NODE_CLASS_MAPPINGS = {
    "MagicCharacterSelector": MagicCharacterSelector,
    "MagicPlaceSelector": MagicPlaceSelector,
    "MagicPromptBuilder": MagicPromptBuilder,
    "MagicPromptEditor": MagicPromptEditor,
    "MagicPainterWrapper": MagicPainterWrapper,
    "MagicStatusDisplay": MagicStatusDisplay
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "MagicCharacterSelector": "Magic: Character Selector 🎭",
    "MagicPlaceSelector": "Magic: Place Selector 🌍",
    "MagicPromptBuilder": "Magic: The Brain 🧠",
    "MagicPromptEditor": "Magic: Prompt Editor ✍️",
    "MagicPainterWrapper": "Magic: The Painter 🎨",
    "MagicStatusDisplay": "Magic: Status Display 💬"
}
