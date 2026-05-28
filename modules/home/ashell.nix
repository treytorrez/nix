{ config, ... }:
let
  c = config.lib.stylix.colors;
in
{
  programs.ashell = {
    enable = true;

    settings = {
      position = "Top";

      modules = {
        left = [ "Workspaces" ];
        center = [ "WindowTitle" ];
        right = [
          "SystemInfo"
          "Settings"
        ];
      };

      window_title.mode = "Title";

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
        #        primary_color    = "#${c.base0D}";
        #        success_color    = "#${c.base0B}";
        #        text_color       = "#${c.base05}";
        #        danger_color     = { base = "#${c.base08}"; weak = "#${c.base09}"; };
        #        background_color = { base = "#${c.base00}"; weak = "#${c.base01}"; strong = "#${c.base03}"; };
        #        secondary_color  = { base = "#${c.base02}"; };
      };
    };
  };

  # ashell loads GTK CSS from this path; use it to strip rounded corners
  xdg.configFile."ashell/style.css".text = ''
    * { border-radius: 0; }
  '';
}
