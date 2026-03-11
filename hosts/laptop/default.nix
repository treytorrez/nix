{ pkgs, ... }:
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
  ];

  networking.hostName = "laptop";

  home-manager.users.treyt = import ../../modules/home;
  home-manager.backupFileExtension = ".bak";

  system.stateVersion = "25.11";
}
