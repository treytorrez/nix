{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      HSA_OVERRIDE_GFX_VERSION = "10.3.2";
      listenAddress = "0.0.0.0:11434";   # was probably "127.0.0.1:11434" by default
    };
  };
}
