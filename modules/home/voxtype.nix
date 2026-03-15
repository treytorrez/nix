{voxtype}:
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
  package = voxtype.packages.${system}.vulkan;
  engiine = "whisper";
  model.name = "base.en";
  service.enable = true;
  settings = {
    hotkey = {
      enabled = false;
      key = "";
      modifiers = [ "LEFTCTRL" "LEFTSHIFT" ];
    };
    whisper = {
      language = "en";
      gpu_isolation = true;
    };
    text.spoken_punctuation = true;
    audio.feedback = {
      enabled = true;
      theme = "subtle";
    };
};
}
