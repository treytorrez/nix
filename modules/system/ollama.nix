{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "10.3.2";
    host = "0.0.0.0";
    port = 11434;
  };
}
