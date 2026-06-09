{ config, ... }: {
  services.hermes-agent = {
    enable = true;

    settings = {
       model = {
        base_url = "http://localhost:11434/v1";
        default = "qwen3.5:4b";
      };
      toolsets = [ "all" ];
      terminal = { backend = "local"; timeout = 180; };
    };

    environmentFiles = [ "/var/lib/hermes/env" ]; # see secrets note below

    container = {
      enable   = true;
      backend  = "docker"; # module auto-enables virtualisation.docker
      hostUsers = [ "treyt" ]; # symlinks ~/.hermes and routes CLI into container
      image = "debian:bookworm-slim";
    };

    addToSystemPackages = true; # puts hermes on PATH; all commands route into container
    restart    = "always";     # default, but explicit
    restartSec = 5;
  };
}
