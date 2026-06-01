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
    ../../modules/system/podman.nix
    ../../modules/system/ollama.nix

  ];

  networking.hostName = "laptop";
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
  hardware.amdgpu.opencl.enable = true;
  users.users.treyt.extraGroups = [
    "video"
    "render"
  ];

  system.stateVersion = "25.11";
}
