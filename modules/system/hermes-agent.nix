{ config, ... }: {
  services.hermes-agent = {
    enable = true;

    settings = {
      model.default = "anthropic/claude-sonnet-4-20250514"; # adjust to your provider
      toolsets = [ "all" ];
      terminal = { backend = "local"; timeout = 180; };
    };

    environmentFiles = [ "/var/lib/hermes/env" ]; # see secrets note below

    container = {
      enable   = true;
      backend  = "docker"; # module auto-enables virtualisation.docker
      hostUsers = [ "your-username" ]; # symlinks ~/.hermes and routes CLI into container
    };

    addToSystemPackages = true; # puts hermes on PATH; all commands route into container
    restart    = "always";     # default, but explicit
    restartSec = 5;
  };
}
