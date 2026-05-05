{ config, pkgs, lib, ... }:

let
  mod = "Mod4";
  term = "kitty";
  menu = "rofi -show drun";
  runner = "rofi -show run";
  browser_personal = "librewolf -P default";
  browser_school  = "librewolf -P School";

  gruvbox = {
    bg      = "#282828";
    fg      = "#ebdbb2";
    yellow  = "#d79921";
    red     = "#cc241d";
    purple  = "#b16286";
    gray1   = "#3c3836";
    gray2   = "#504945";
    gray3   = "#7c6f64";
    gray4   = "#a89984";
  };
in
{
  home.packages = with pkgs; [
#    rofi
    picom
#    dunst
    i3status-rust # is pulled in by programs.i3status-rust.enable
  ];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;

    config = {
      modifier = mod;
      terminal = term;
      menu = menu;
      fonts = { names = [ "AtkynsonMono Nerd Font" "monospace" ]; size = 10.0; };
      gaps = { inner = 0; outer = 0; smartGaps = true; smartBorders = "on"; };
      focus.followMouse = true;
      floating.modifier = mod;

      keybindings = lib.mkOptionDefault {
        "${mod}+Return"       = "exec ${term}";
        "${mod}+z"            = "exec ${browser_personal}";
        "${mod}+Shift+z"      = "exec ${browser_school}";
        "${mod} --release"    = "exec ${menu}";
        "${mod}+Shift+d"       = "exec ${runner}";
        "${mod}+space"        = "floating toggle";
        "${mod}+Shift+q"            = "kill";

        # Focus
        "${mod}+h"            = "focus left";
        "${mod}+j"            = "focus down";
        "${mod}+k"            = "focus up";
        "${mod}+l"            = "focus right";

        # Move
        "${mod}+Shift+h"      = "move left";
        "${mod}+Shift+j"      = "move down";
        "${mod}+Shift+k"      = "move up";
        "${mod}+Shift+l"      = "move right";

        # Layout
        "${mod}+b"            = "split h";
        "${mod}+v"            = "split v";
        "${mod}+f"            = "fullscreen toggle";
        "${mod}+s"            = "layout stacking";
        "${mod}+w"            = "layout tabbed";
        "${mod}+e"            = "layout toggle split";
        "${mod}+Shift+space"  = "focus mode_toggle";

        # Workspaces
        "${mod}+1"            = "workspace number 1";
        "${mod}+2"            = "workspace number 2";
        "${mod}+3"            = "workspace number 3";
        "${mod}+4"            = "workspace number 4";
        "${mod}+5"            = "workspace number 5";
        "${mod}+6"            = "workspace number 6";
        "${mod}+7"            = "workspace number 7";
        "${mod}+8"            = "workspace number 8";
        "${mod}+9"            = "workspace number 9";
        "${mod}+0"            = "workspace number 10";

        "${mod}+Shift+1"      = "move container to workspace number 1";
        "${mod}+Shift+2"      = "move container to workspace number 2";
        "${mod}+Shift+3"      = "move container to workspace number 3";
        "${mod}+Shift+4"      = "move container to workspace number 4";
        "${mod}+Shift+5"      = "move container to workspace number 5";
        "${mod}+Shift+6"      = "move container to workspace number 6";
        "${mod}+Shift+7"      = "move container to workspace number 7";
        "${mod}+Shift+8"      = "move container to workspace number 8";
        "${mod}+Shift+9"      = "move container to workspace number 9";
        "${mod}+Shift+0"      = "move container to workspace number 10";

        # i3 control
        "${mod}+Shift+c"      = "reload";
        "${mod}+Shift+r"      = "restart";
        "${mod}+Shift+e"      = "exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'";
        "${mod}+r"            = "mode resize";
      };

      modes.resize = {
        h      = "resize shrink width 10 px or 10 ppt";
        j      = "resize grow height 10 px or 10 ppt";
        k      = "resize shrink height 10 px or 10 ppt";
        l      = "resize grow width 10 px or 10 ppt";
        Left   = "resize shrink width 10 px or 10 ppt";
        Down   = "resize grow height 10 px or 10 ppt";
        Up     = "resize shrink height 10 px or 10 ppt";
        Right  = "resize grow width 10 px or 10 ppt";
        Return = "mode default";
        Escape = "mode default";
      };

      colors = {
        focused         = { border = gruvbox.yellow; background = gruvbox.bg; text = gruvbox.fg;    indicator = gruvbox.yellow; childBorder = gruvbox.yellow; };
        focusedInactive = { border = gruvbox.gray1;  background = gruvbox.bg; text = gruvbox.gray4; indicator = gruvbox.gray1;  childBorder = gruvbox.gray1; };
        unfocused       = { border = gruvbox.gray1;  background = gruvbox.bg; text = gruvbox.gray3; indicator = gruvbox.gray1;  childBorder = gruvbox.gray1; };
        urgent          = { border = gruvbox.red;    background = gruvbox.bg; text = gruvbox.fg;    indicator = gruvbox.red;    childBorder = gruvbox.red; };
        placeholder     = { border = gruvbox.bg;     background = gruvbox.bg; text = gruvbox.fg;    indicator = gruvbox.bg;     childBorder = gruvbox.bg; };
        background      = gruvbox.bg;
      };

      assigns = {
        "1" = [
          { class = "^LibreWolf$"; }
          { title = "^LibreWolf$"; }
          { class = "^firefox$"; }
          { title = "^firefox$"; }
        ];
        "2" = [
          { class = "^Simple Terminal$"; }
          { title = "^Simple Termina$"; }
          { title = "^kitty"; }
          #{ class = "^kitty"; }
        ];
        "3" = [
          { class = "^tidal-hifi$"; }
          { class = "^high-tide$"; }
        ];
      };
      floating.criteria = [
        {
          title = "feh";
	}
      ]; 

      startup = [
        { command = "picom --daemon";  notification = false; }
        { command = "nm-applet";       notification = false; }
#        { command = "dunst";           notification = false; }
        # { command = "feh --bg-scale ~/Pictures/wallpaper.jpg"; notification = false; }
      ];

      bars = [{
        position = "top";
        statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
        fonts = { names = [ "AtkynsonMono Nerd Font" "monospace" ]; size = 15.0; };
        colors = {
          background      = gruvbox.bg;
          statusline      = gruvbox.fg;
          separator       = gruvbox.gray2;
          focusedWorkspace  = { border = gruvbox.yellow; background = gruvbox.yellow; text = gruvbox.bg; };
          activeWorkspace   = { border = gruvbox.gray1;  background = gruvbox.gray1;  text = gruvbox.fg; };
          inactiveWorkspace = { border = gruvbox.bg;     background = gruvbox.bg;     text = gruvbox.gray3; };
          urgentWorkspace   = { border = gruvbox.red;    background = gruvbox.red;    text = gruvbox.fg; };
          bindingMode       = { border = gruvbox.purple; background = gruvbox.purple; text = gruvbox.fg; };
        };
      }];
    };
  };
}
