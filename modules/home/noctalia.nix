{ config, pkgs, ... }:
{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    launch_apps_as_systemd_services = true;

  };
}
