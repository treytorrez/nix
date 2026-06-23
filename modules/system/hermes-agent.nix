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
        base_url = "http://127.0.0.1:11434/v1";
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

    # Secret is declared in host default.nix:
    #   sops.secrets."hermes-env".sopsFile = ../../secrets/hermes-env.yaml;
    environmentFiles = [
      config.sops.secrets."hermes-env".path
    ];

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
    };

    addToSystemPackages = true;
    restart = "always";
    restartSec = 5;
  };
}
