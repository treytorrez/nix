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
        #  {
	  #  block = "custom";
	  #  command = "echo";
	  #  interval = "once";
	  #  format = "$text.str(w:80)";
        #  }
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
          format = " $icon $percentage ";
          disconnected_format = " $icon off ";
        }
        {
          block = "net";
          format = " $icon {$signal_strength $ssid $frequency|Wired connection} via $device ";
          missing_format = "  no wifi  ";
          interval = 5;
        }
        {
          block = "battery";
          interval = 10;
          format = " $icon $percentage ";
        }
	{
	  block = "backlight"; 
	  format = " $icon $brightness "; 
	  missing_format = " $icon N/A ";
	}
        {
          block = "sound";
          format =" $icon {$volume.eng(w:2) }";
	  show_volume_when_muted = true;
	  driver = "pulseaudio";
        }
      ];
    };
  };
}
