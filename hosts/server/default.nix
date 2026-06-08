{
  pkgs,
  lib,
  config,
  inputs,
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
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "wezterm.nvim"
           ];
  nixpkgs.overlays = [
    (final: prev: {
      canon = final.callPackage ../../packages/canon.nix { canonSrc = inputs.canonSrc; };
      nixvim = inputs.nixvim.packages.${final.system}.default;
    })

  ];

  home-manager.users.treyt = import ../../modules/home;
  home-manager.backupFileExtension = ".bak";

  # In your hardware config or host module:
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.open = false;  # see the note above
  hardware.nvidia.modesetting.enable = true;
  users.users.treyt.extraGroups = [
    "video"
    "render"
    "docker"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
