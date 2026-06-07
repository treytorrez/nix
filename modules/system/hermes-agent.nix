{
  config,
  pkgs,
  ...
}:
{
  services.hermes-agent = {
    enable = true;

    settings = {
      model = {
        base_url = "http://localhost:11434/v1"; # "baseurl" in server branch is wrong key
        default = "qwen3.5:4b";
      };

      toolsets = [ "all" ];

      terminal = {
        backend = "local";
        timeout = 180;
      };

      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };

      tts.provider = "piper";
    };

    # Both paths kept — remove whichever doesn't exist or you don't use
    environmentFiles = [
      "/var/lib/hermes/env"
      "/home/treyt/hermes-env"
    ];

    # Combined from both branches
    extraDependencyGroups = [ "messaging" "hindsight" "voice" ];

    extraPackages = [
      pkgs.imagemagick
      pkgs.pandoc
      pkgs.curl
      pkgs.wget
    ];

    container = {
      enable = true;
      backend = "docker";
      hostUsers = [ "treyt" ];
      image = "debian:bookworm-slim";
      # extraOptions = [
      #   "--gpus"
      #   "all"
      # ];
    };

    addToSystemPackages = true;
    restart = "always";
    restartSec = 5;
  };
}
