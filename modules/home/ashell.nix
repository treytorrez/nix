{ pkgs, ... }:
{
  programs.ashell = {
    enable = true;
    package = pkgs.ashell;
    systemd.enable = true;

    settings = {
      position = "Top";

      modules = {
        left = [ "Workspaces" ];
        center = [ "WindowTitle" ];
        right = [
          "SystemInfo"
          "Settings"
          "Clock"
          "MyVolume"
        ];
      };

      window_title.mode = "Title";
      Tempo = {
        clock_format = "%D  %I:%M%P";
      };

      system_info = {
        indicators = [ "Memory" ];
        interval = 5;
        memory = {
          warn_threshold = 70;
          alert_threshold = 85;
        };
      };

      settings = {
        indicators = [
          "Network"
          "Battery"
        ];
        battery_format = "IconAndPercentage";
        network_indicator_format = "Icon";
      };

      appearance = {
        style = "Solid";
      };
      osd = {
        enabled = true; # Disabled by default; set to true to enable the OSD overlay;
        timeout = 1500; # Auto-hide delay in milliseconds;
        show_volume_percentage = true; # Show percentage text next to volume/mic bar
        show_brightness_percentage = true;# Show percentage text next to brightness bar
      };
    };
  };

  xdg.configFile."ashell/style.css".text = ''
    * { border-radius: 0; }
  '';
}
