{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Positioning and size
        width = 800; # Twice the typical 300
        height = 600; # Twice the typical 300
        offset = "30x50";
        origin = "top-right";

        # Typography
        font = "AtkinsonMono Nerd Font 15";

        # Gruvbox dark hard colors
        frame_color = "#fe8019";
        frame_width = 2;
        separator_color = "frame";

        # Layout
        padding = 16;
        horizontal_padding = 16;
        text_icon_padding = 16;
        gap_size = 8;

        # Behavior
        timeout = 5;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        show_indicators = true;
      };

      urgency_low = {
        background = "#1d2021";
        foreground = "#928374";
        frame_color = "#928374";
        timeout = 4;
      };

      urgency_normal = {
        background = "#1d2021";
        foreground = "#ebdbb2";
        frame_color = "#fe8019";
        timeout = 6;
      };

      urgency_critical = {
        background = "#1d2021";
        foreground = "#fbf1c7";
        frame_color = "#fb4934";
        timeout = 0; # Don't auto-dismiss
      };
    };
  };
}
