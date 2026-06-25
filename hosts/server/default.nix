{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/boot.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/desktop.nix
    ../../modules/system/audio.nix
    ../../modules/system/programs.nix
    ../../modules/system/packages.nix
    ../../modules/system/users.nix
    ../../modules/system/fonts.nix
    ../../modules/system/focus-blacklist.nix
    ../../modules/system/focus-mode.nix
    ../../modules/system/ld.nix
    ../../modules/system/tailscale.nix
    ../../modules/system/ollama.nix
    ../../modules/system/hermes-agent.nix
    ../../modules/system/searxng.nix

  ];

  networking.hostName = "server";

  nixpkgs.config.allowUnfree = true;

  home-manager.users.treyt = import ../../modules/home;
  home-manager.backupFileExtension = ".bak";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };
  users.users.treyt.extraGroups = [
    "video"
    "render"
    "docker"
  ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "openrouter-key".sopsFile = ../../secrets/openrouter.yaml;
      "hermes-env".sopsFile = ../../secrets/hermes-env.yaml;
      "searxng-secret" = {
        sopsFile = ../../secrets/searxng.yaml;
        key = "secret_key";
      };
    };
  };

  system.stateVersion = "26.05";
}
