{ config, pkgs, lib, ... }:

{
  programs.i3status-rust = {
    enable = true;

    bars.default = {
      theme = "gruvbox-dark";
      icons = "material-nf";

      blocks = [
        {
          block = "focused_window";
        }
        {
        }
        {
          block = "time";
          interval = 1;
          format = " $timestamp.datetime(f:'%a %b %d  %H:%M:%S') ";
          theme_overrides = {
            idle_bg = "#282828";
            idle_fg = "#d79921";
          };
        }
        {
          block = "bluetooth";
          mac = "XX:XX:XX:XX:XX:XX"; # replace with your device MAC
          format = " BT: $percentage ";
          disconnected_format = " BT: off ";
        }
        {
          block = "net";
          format = " $ssid $signal_strength ";
          missing_format = " no wifi ";
          interval = 5;
        }
        {
          block = "battery";
          interval = 10;
          format = " $icon $percentage ";
        }
        {
          block = "sound";
          format =" $icon {$volume.eng(w:2) }";
	  driver = "pulseaudio";
        }
      ];
    };
  };
}
