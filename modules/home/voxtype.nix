{ pkgs, voxtype, ... }:
{
  programs.voxtype = {
    enable = true;
    # The VoxType package to use. Use the flake's wrapped packages:
    #  Whisper packages:
    #  - packages.default: CPU-only Whisper (works everywhere)
    #  - packages.vulkan: Vulkan GPU acceleration (AMD/NVIDIA/Intel)
    #  - packages.rocm: ROCm/HIP acceleration (AMD only)
    #
    #  ONNX packages (for parakeet, moonshine, sensevoice, etc.):
    #  - packages.onnx: CPU-only ONNX engines
    #  - packages.onnx-cuda: CUDA acceleration (NVIDIA)
    #  - packages.onnx-rocm: ROCm acceleration (AMD, Parakeet only)
    #
    #  All packages include runtime dependencies (wtype, dotool, ydotool, etc.).
    package = voxtype.packages.${pkgs.stdenv.hostPlatform.system}.vulkan;
    engine = "whisper";
    model.name = "base.en";
    service.enable = true;
    settings = {
      hotkey = {
        enabled = true;
        key = "CALCULATOR";
        modifiers = [ "RIGHTCTRL" ];
      };
      whisper = {
        language = "en";
        gpu_isolation = true;
      };
      text.spoken_punctuation = true;
      audio.feedback = {
        enabled = true;
        theme = "mechanical";
        volume = 0.4;
      };
      output.notification = {
        on_recording_start = true;
        pn_recording_stop = true;
        on_transcription = true;
      };
    };
  };
}
