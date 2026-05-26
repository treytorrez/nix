{
  config,
  pkgs,
  lib,
  ...
}:

let
  mod = "SUPER";
  term = "kitty";
  menu = "rofi -show drun";
  runner = "rofi -show run";
  browser_personal = "librewolf -P default";
  browser_school = "librewolf -P school";

  gruvbox = {
    dark0_hard = "1d2021";
    gray_245 = "928374";
    gray_244 = "928374";
    light0_hard = "f9f5d7";
    bright_orange = "fe8019";
    neutral_orange = "d65d0e";
    faded_orange = "af3a03";
    bright_red = "fb4934";
  };
in
{
  home.packages = with pkgs; [
    hyprpaper
    rofi
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    #configType = "lua";

    settings = {
      "$mod" = mod;

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgb(${gruvbox.bright_orange})";
        "col.inactive_border" = "rgb(${gruvbox.gray_245})";
      };
      # TODO: animations off

      # hopefully this is using the iGPU
      # env = "AQ_DRM_DEVICES, /dev/dri/by-path/pci-0000:07:00.0-card";
      # TODO: monitor scale 1.0, change other apps to be bigger
      monitor = "eDP-2, 2560x1600@75, 0x0, 1.2";

      input = {
        follow_mouse = 1;
      };

      # Regular binds (on press)
      bind = [
        "$mod, Return, exec, ${term}"
        "$mod, Z, exec, ${browser_personal}"
        "$mod SHIFT, Z, exec, ${browser_school}"
        "$mod, D, exec, ${menu}"
        "$mod SHIFT, D, exec, ${runner}"
        "$mod, Space, togglefloating"
        "$mod SHIFT, Q, killactive"

        # Focus
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        # Move
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        # Layout
        #"$mod, F, fullscreen"
        "$mod SHIFT, F, fullscreenstate, 0 2"
        "$mod, F, fullscreenstate, 0 0"

        "$mod, E, togglesplit" # closest to i3's split toggle

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Hyprland control
        "$mod SHIFT, R, exec, hyprctl reload"
        "$mod SHIFT, E, exit"
        #"$mod TAB,  L, hyprexpo:expo, select"

        # Enter resize submap
        "$mod, R, submap, resize"
      ];

      windowrulev2 = [
        "workspace 1, class:^(LibreWolf)$"
        "workspace 1, class:^(firefox)$"
        "workspace 2, class:^(kitty)$"
        # FIXME: claude botched it or something
        #"workspace 3, class:^(tidal-hifi)$, selec, selec, selec, selecuttt"
        "workspace 3, class:^(high-tide)$"
        "float, title:^(feh)$"
      ];

      exec-once = [
        "nm-applet --indicator"
        "hyprpaper"
        # TODO: could these autostart apps be systemd things
        "ashell"
        "lxqt-powermanagement"
      ];
    };

    # Submaps can't be expressed as nested attribute sets —
    # they're positional blocks in hyprland.conf, so extraConfig handles them.
    extraConfig = ''
      submap = resize
      binde = , H, resizeactive, -20 0
      binde = , L, resizeactive, 20 0
      binde = , K, resizeactive, 0 -20
      binde = , J, resizeactive, 0 20
      bind  = , Return, submap, reset
      bind  = , Escape, submap, reset
      submap = reset
    '';
    plugins = [
      #pkgs.hyprlandPlugins.hyprexpo
      # TODO: Worth configuring if i have a status bar?
      #pkgs.hyprlandPlugins.hyprbars
    ];
  };
}
