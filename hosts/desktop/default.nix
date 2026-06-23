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
    ../../modules/system/tailscale.nix
  ];

  networking.hostName = "desktop";
  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [ "broadcom-sta" ];

  home-manager.users.treyt = import ../../modules/home;
  home-manager.backupFileExtension = ".bak";

  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];
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

  system.stateVersion = "26.05";
}
