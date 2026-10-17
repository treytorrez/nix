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
    ../../modules/system/llama-server.nix
    ../../modules/system/searxng.nix
    ../../modules/system/secrets.nix
    ../../modules/system/stylix.nix
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

  # Shared secrets (password, tailscale, openrouter, wifi) come from
  # modules/system/secrets.nix; this host adds its own services' secrets.
  sops.secrets."searxng-secret".sopsFile = ../../secrets/searxng.yaml;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +10";
  };
  system.stateVersion = "26.05";
}
