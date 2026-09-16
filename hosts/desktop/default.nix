{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [ "broadcom-sta" ];
    };
  };
in
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
    ../../modules/system/tailscale.nix
    ../../modules/system/stylix.nix
  ];

  networking.hostName = "desktop";
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [ "broadcom-sta" ];

  home-manager.users.treyt = import ../../modules/home;
  home-manager.backupFileExtension = ".bak";
  nixpkgs.config.allowUnfree = true;

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];
  # You may have to pin this to avoid wifi breakage
  # Pinned to unstable branch to grab a fix for the wifi
  boot.kernelPackages = pkgsUnstable.linuxKernel.packages.linux_7_2;
  boot.blacklistedKernelModules = [
    "b43"
    "bcma"
    "brcmsmac"
    "ssb"
    "brcmfmac"
    "brcmutil"
  ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=imac27_122
  '';
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +3";
  };
  system.stateVersion = "26.05";
}
