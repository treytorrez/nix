{ pkgs, hostname, ... }:
{
  services.ollama = {
    enable = true;
    package =
      if hostname == "laptop" then
        pkgs.ollama-rocm
      else
        pkgs.ollama-cuda.override { cudaArches = [ "61" ]; };
    rocmOverrideGfx = if hostname == "laptop" then "10.3.2" else null;
    host = "0.0.0.0";
    port = 11434;
  };
};
}
