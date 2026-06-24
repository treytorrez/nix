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
      tempo = {
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

      CustomModule = {
        name = "MyVolume";
        type = "listen_cmd";
        command = "~/Dev/pactl-mon/pactl-mon";
      };

      appearance = {
        style = "Solid";
      };
    };
  };

  xdg.configFile."ashell/style.css".text = ''
    * { border-radius: 0; }
  '';
}
