{
  config,
  pkgs,
  lib,
  ...
}:

let
  mod = "Mod4";
  term = "kitty";
  menu = "rofi -show drun";
  runner = "rofi -show run";
  browser_personal = "librewolf -P default";
  browser_school = "librewolf -P school";

  gruvbox = {

    dark0_hard = "#1d2021";
    dark0 = "#282828";
    dark0_soft = "#32302f";
    dark1 = "#3c3836";
    dark2 = "#504945";
    dark3 = "#665c54";
    dark4 = "#7c6f64";
    dark4_256 = "#7c6f64";
    #
    gray_245 = "#928374";
    gray_244 = "#928374";
    #
    light0_hard = "#f9f5d7";
    light0 = "#fbf1c7";
    light0_soft = "#f2e5bc";
    light1 = "#ebdbb2";
    light2 = "#d5c4a1";
    light3 = "#bdae93";
    light4 = "#a89984";
    light4_256 = "#a89984";
    #
    bright_red = "#fb4934";
    bright_green = "#b8bb26";
    bright_yellow = "#fabd2f";
    bright_blue = "#83a598";
    bright_purple = "#d3869b";
    bright_aqua = "#8ec07c";
    bright_orange = "#fe8019";
    #
    neutral_red = "#cc241d";
    neutral_green = "#98971a";
    neutral_yellow = "#d79921";
    neutral_blue = "#458588";
    neutral_purple = "#b16286";
    neutral_aqua = "#689d6a";
    neutral_orange = "#d65d0e";
    #
    faded_red = "#9d0006";
    faded_green = "#79740e";
    faded_yellow = "#b57614";
    faded_blue = "#076678";
    faded_purple = "#8f3f71";
    faded_aqua = "#427b58";
    faded_orange = "#af3a03";

  };
in
{
  home.packages = with pkgs; [
    #    rofi
    picom
    #    dunst
    i3status-rust # is pulled in by programs.i3status-rust.enable
  ];

  #   xsession.windowManager.i3 = {
  #     enable = true;
  #     package = pkgs.i3;
  # 
  #     config = {
  #       modifier = mod;
  #       terminal = term;
  #       menu = menu;
    #       fonts = {
    #         names = [
    #           "AtkynsonMono Nerd Font"
    #           "monospace"
    #         ];
    #         size = 20.0;
  #       };
    #       gaps = {
    #         inner = 0;
    #         outer = 0;
    #         smartGaps = true;
    #         smartBorders = "on";
  #       };
  #       focus.followMouse = true;
  #       floating.modifier = mod;
  # 
    #       keybindings = lib.mkOptionDefault {
    #         "${mod}+Return" = "exec ${term}";
    #         "${mod}+z" = "exec ${browser_personal}";
    #         "${mod}+Shift+z" = "exec ${browser_school}";
    #         "${mod} --release" = "exec ${menu}";
    #         "${mod}+Shift+d" = "exec ${runner}";
    #         "${mod}+space" = "floating toggle";
    #         "${mod}+Shift+q" = "kill";
    # 
    #         # Focus
    #         "${mod}+h" = "focus left";
    #         "${mod}+j" = "focus down";
    #         "${mod}+k" = "focus up";
    #         "${mod}+l" = "focus right";
    # 
    #         # Move
    #         "${mod}+Shift+h" = "move left";
    #         "${mod}+Shift+j" = "move down";
    #         "${mod}+Shift+k" = "move up";
    #         "${mod}+Shift+l" = "move right";
    # 
    #         # Layout
    #         "${mod}+b" = "split h";
    #         "${mod}+v" = "split v";
    #         "${mod}+f" = "fullscreen toggle";
    #         "${mod}+s" = "layout stacking";
    #         "${mod}+w" = "layout tabbed";
    #         "${mod}+e" = "layout toggle split";
    #         "${mod}+Shift+space" = "focus mode_toggle";
    # 
    #         # Workspaces
    #         "${mod}+1" = "workspace number 1";
    #         "${mod}+2" = "workspace number 2";
    #         "${mod}+3" = "workspace number 3";
    #         "${mod}+4" = "workspace number 4";
    #         "${mod}+5" = "workspace number 5";
    #         "${mod}+6" = "workspace number 6";
    #         "${mod}+7" = "workspace number 7";
    #         "${mod}+8" = "workspace number 8";
    #         "${mod}+9" = "workspace number 9";
    #         "${mod}+0" = "workspace number 10";
    # 
    #         "${mod}+Shift+1" = "move container to workspace number 1";
    #         "${mod}+Shift+2" = "move container to workspace number 2";
    #         "${mod}+Shift+3" = "move container to workspace number 3";
    #         "${mod}+Shift+4" = "move container to workspace number 4";
    #         "${mod}+Shift+5" = "move container to workspace number 5";
    #         "${mod}+Shift+6" = "move container to workspace number 6";
    #         "${mod}+Shift+7" = "move container to workspace number 7";
    #         "${mod}+Shift+8" = "move container to workspace number 8";
    #         "${mod}+Shift+9" = "move container to workspace number 9";
    #         "${mod}+Shift+0" = "move container to workspace number 10";
    # 
    #         # i3 control
    #         "${mod}+Shift+c" = "reload";
    #         "${mod}+Shift+r" = "restart";
    #         "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'";
    #         "${mod}+r" = "mode resize";
  #       };
  # 
    #       modes.resize = {
    #         h = "resize shrink width 10 px or 10 ppt";
    #         j = "resize grow height 10 px or 10 ppt";
    #         k = "resize shrink height 10 px or 10 ppt";
    #         l = "resize grow width 10 px or 10 ppt";
    #         Left = "resize shrink width 10 px or 10 ppt";
    #         Down = "resize grow height 10 px or 10 ppt";
    #         Up = "resize shrink height 10 px or 10 ppt";
    #         Right = "resize grow width 10 px or 10 ppt";
    #         Return = "mode default";
    #         Escape = "mode default";
  #       };
  # 
    #       colors = {
    #         focused = {
    #           border = gruvbox.bright_orange;
    #           background = gruvbox.dark0_hard;
    #           text = gruvbox.light0_hard;
    #           indicator = gruvbox.neutral_orange;
    #           childBorder = gruvbox.faded_orange;
    #         };
    #         focusedInactive = {
    #           border = gruvbox.gray_245;
    #           background = gruvbox.dark0_hard;
    #           text = gruvbox.gray_244;
    #           indicator = gruvbox.gray_245;
    #           childBorder = gruvbox.gray_245;
    #         };
    #         unfocused = {
    #           border = gruvbox.gray_245;
    #           background = gruvbox.dark0_hard;
    #           text = gruvbox.gray_244;
    #           indicator = gruvbox.gray_245;
    #           childBorder = gruvbox.gray_245;
    #         };
    #         urgent = {
    #           border = gruvbox.bright_red;
    #           background = gruvbox.dark0_hard;
    #           text = gruvbox.light0_hard;
    #           indicator = gruvbox.bright_red;
    #           childBorder = gruvbox.bright_red;
    #         };
    #         placeholder = {
    #           border = gruvbox.dark0_hard;
    #           background = gruvbox.dark0_hard;
    #           text = gruvbox.light0_hard;
    #           indicator = gruvbox.dark0_hard;
    #           childBorder = gruvbox.dark0_hard;
    #         };
    #         background = gruvbox.dark0_hard;
  #       };
  # 
    #       assigns = {
    #         "1" = [
    #           { class = "^LibreWolf$"; }
    #           { title = "^LibreWolf$"; }
    #           { class = "^firefox$"; }
    #           { title = "^firefox$"; }
    #         ];
    #         "2" = [
    #           { class = "^Simple Terminal$"; }
    #           { title = "^Simple Termina$"; }
    #           { title = "^kitty"; }
    #           #{ class = "^kitty"; }
    #         ];
    #         "3" = [
    #           { class = "^tidal-hifi$"; }
    #           { class = "^high-tide$"; }
    #         ];
  #       };
    #       floating.criteria = [
    #         {
    #           title = "feh";
  #         }
  #       ];
  # 
    #       startup = [
    #         {
    #           command = "picom --daemon";
    #           notification = false;
    #         }
    #         {
    #           command = "nm-applet";
    #           notification = false;
    #         }
    #         #        { command = "dunst";           notification = false; }
    #         {
    #           command = "feh --bg-scale ~/Pictures/wallpaper.jpg";
    #           notification = false;
  #         }
  #       ];
  # 
  #       bars = [
  #         {
  #           position = "top";
  #           statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
    #           fonts = {
    #             names = [
    #               "AtkynsonMono Nerd Font"
    #               "monospace"
    #             ];
    #             size = 20.0;
  #           };
  #           colors = {
  #             background = gruvbox.dark0_hard;
  #             statusline = gruvbox.light0_hard;
  #             separator = gruvbox.gray_244;
    #             focusedWorkspace = {
    #               border = gruvbox.bright_orange;
    #               background = gruvbox.faded_orange;
    #               text = gruvbox.dark0_hard;
  #             };
    #             activeWorkspace = {
    #               border = gruvbox.gray_245;
    #               background = gruvbox.gray_245;
    #               text = gruvbox.light0_hard;
  #             };
    #             inactiveWorkspace = {
    #               border = gruvbox.dark0_hard;
    #               background = gruvbox.dark0_hard;
    #               text = gruvbox.gray_244;
  #             };
    #             urgentWorkspace = {
    #               border = gruvbox.neutral_red;
    #               background = gruvbox.neutral_red;
    #               text = gruvbox.light0_hard;
  #             };
  #             bindingMode = {
  #               border = gruvbox.neutral_purple;
  #               background = gruvbox.neutral_purple;
  #               text = gruvbox.light0_hard;
  #             };
  #           };
  #         }
  #       ];
  #     };
  #   };
}
