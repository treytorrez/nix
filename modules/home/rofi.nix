{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    ##color##theme = "sidebar";
    ##color##font = "AtkynsonMono Nerd Font monospace 15";
    package = pkgs.rofi;
    modes = [
      "drun"
      "run"
      "window"
      "ssh"  
      "combi"
    ];
    extraConfig = {
      show-icons = true;
    };
  };
}
