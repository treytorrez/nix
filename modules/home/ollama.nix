{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
      host = "0.0.0.0";   # was probably "127.0.0.1:11434" by default
      acceleration = null; # auto detecs rocm
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      # HSA_OVERRIDE_GFX_VERSION = "10.3.2"; # WAS USED FOR COLAB STUFF
    };
  };
}
