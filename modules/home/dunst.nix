{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {

      urgency_low = {
        #background = "#1d2021";
        #foreground = "#928374";
        #frame_color = "#928374";
        timeout = 4;
      };

      urgency_normal = {
        #background = "#1d2021";
        #foreground = "#ebdbb2";
        #frame_color = "#fe8019";
        timeout = 6;
      };

      urgency_critical = {
        #background = "#1d2021";
        #foreground = "#fbf1c7";
        #frame_color = "#fb4934";
        timeout = 0; # Don't auto-dismiss
      };
    };
  };
}
