{ pkgs, ... }:
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind = [
      "$mod, z, exec, firefox"
      ", Print, exec, grimblast copy area"
      "$mod, Q, exec, "
      ""
    ]
    ++ (
      # workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9
      )
    );
    config = {
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
      };

      decoration = {
        rounding = 10;
      };
    };
  };
}
