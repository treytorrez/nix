{ config, pkgs, ... }:
{
  programs.noctalia = {
    enable = true;
    settings = {
      systemd.enable = true;
      launch_apps_as_systemd_services = true;
    };

  };
}
