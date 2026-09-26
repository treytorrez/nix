{
  config,
  pkgs,
  lib,
  ...
}:

let
  mod = "SUPER";
  term = "foot";
  menu = "mew-run -i -p open:";
  runner = "mew-run -i -p run:";
  browser_personal = "librewolf -P default";
  browser_school = "librewolf -P school";

  # Smart Enter: if running inside tmux, split the window;
  # otherwise spawn a new foot terminal.
  # The terminal package can be overridden by passing termPkg as an argument.
  # TODO: I feel like this is doable but sending stuff like this doesn't work. I presume this is a Nix issue
  # also sending keystrokes is hacky and *also* does not work :(
  #
  # smartEnter = pkgs.writeShellScript "smart-enter" ''
  #   set -euo pipefail
  #   if [ -n "$TMUX" ]; then
  #     tmux split-window
  #   else
  #     footclient &
  #   fi
  # '';
in
{
  home.packages = with pkgs; [
    hyprpaper
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "lua";

    # SDDM launches Hyprland via uwsm, which manages the graphical session
    # (hyprland-session.target) itself. home-manager's systemd integration
    # injects an exec-once that runs `systemctl --user stop
    # hyprland-session.target` on startup, which kills the uwsm session and
    # causes a black screen on login. Disable it so uwsm owns the session.
    systemd.enable = false;

    settings = {
      # -> local mod = "SUPER"
      mod = {
        _var = mod;
      };

      monitor = {
        output = "eDP-2";
        mode = "preferred";
        # mode = "2560x1600@75";   # what the old conf line pinned
        position = "0x0";
        scale = "1.60";
        vrr = 1;
      };

      # TODO: monitor scale 1.0, change other apps to be bigger
      # monitor = lib.mkMerge [
      #   (lib.mkIf (config.networking.hostName == "laptop") [
      #     { output = "eDP-2"; mode = "2560x1600@75"; position = "0x0"; scale = "1.60"; }
      #   ])
      #   (lib.mkIf (config.networking.hostName == "desktop") [
      #     { output = "eDP-2"; mode = "2560x1600@60"; position = "0x0"; scale = "1.60"; }
      #   ])
      #   (lib.mkIf (config.networking.hostName == "server") [
      #     { output = "eDP-2"; mode = "1600x900@15"; position = "0x0"; scale = "1.0"; }
      #   ])
      # ];

      # hopefully this is using the iGPU
      # it, in fact, breaks entirely
      # (note: uwsm users are told to put AQ_* vars in ~/.config/uwsm/env-hyprland instead)
      # hl.env("AQ_DRM_DEVICES", "/dev/dri/by-path/pci-0000:07:00.0-card");

      # -> hl.config({ ... })
      config = {
        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 4;
          ##color## "col.active_border" = "rgb(${gruvbox.bright_orange})";
          ##color## "col.inactive_border" = "rgb(${gruvbox.gray_245})";
        };
        decoration = {
          rounding = 0;
          blur.enabled = false;
          shadow.enabled = false;
        };
        misc = {
          disable_splash_rendering = true;
          disable_hyprland_logo = true;
        };
        animations = {
          enabled = false;
        };
        input = {
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = false;
          };
        };
      };

      # -> one hl.bind(...) per list entry
      bind = [
        # was bindr: releasing SUPER toggles the launcher
        { _args = [ "${mod} + SUPER_L" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pkill mew || ${menu}")'') { release = true; } ]; }

        # Regular binds (on press)
        # (the smartEnter variant is still just a TODO — see the let block)
        { _args = [ "${mod} + RETURN" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${term}")'') ]; }
        { _args = [ "${mod} + SHIFT + RETURN" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${term}")'') ]; }
        { _args = [ "${mod} + Z" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${browser_personal}")'') ]; }
        { _args = [ "${mod} + SHIFT + Z" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${browser_school}")'') ]; }
        { _args = [ "${mod} + D" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${menu}")'') ]; }
        { _args = [ "${mod} + SHIFT + D" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${runner}")'') ]; }
        { _args = [ "${mod} + N" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("footclient nvim")'') ]; }
        { _args = [ "${mod} + SHIFT + N" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("footclient nvim cd /etc/nixos/")'') ]; }
        { _args = [ "${mod} + SPACE" (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'') ]; }
        { _args = [ "${mod} + SHIFT + Q" (lib.generators.mkLuaInline ''hl.dsp.window.close()'') ]; }

        # Focus
        { _args = [ "${mod} + H" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "l" })'') ]; }
        { _args = [ "${mod} + J" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "d" })'') ]; }
        { _args = [ "${mod} + K" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "u" })'') ]; }
        { _args = [ "${mod} + L" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "r" })'') ]; }

        # Move
        { _args = [ "${mod} + SHIFT + H" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "l" })'') ]; }
        { _args = [ "${mod} + SHIFT + J" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "d" })'') ]; }
        { _args = [ "${mod} + SHIFT + K" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "u" })'') ]; }
        { _args = [ "${mod} + SHIFT + L" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "r" })'') ]; }

        # Layout
        # "${mod}, F, fullscreen"
        { _args = [ "${mod} + SHIFT + F" (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "set" })'') ]; }
        { _args = [ "${mod} + F" (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen_state({ internal = 0, client = 0, action = "set" })'') ]; }

        # Workspaces
        { _args = [ "${mod} + 1" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 1 })'') ]; }
        { _args = [ "${mod} + 2" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 2 })'') ]; }
        { _args = [ "${mod} + 3" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 3 })'') ]; }
        { _args = [ "${mod} + 4" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 4 })'') ]; }
        { _args = [ "${mod} + 5" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 5 })'') ]; }
        { _args = [ "${mod} + 6" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 6 })'') ]; }
        { _args = [ "${mod} + 7" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 7 })'') ]; }
        { _args = [ "${mod} + 8" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 8 })'') ]; }
        { _args = [ "${mod} + 9" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 9 })'') ]; }
        { _args = [ "${mod} + 0" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = 10 })'') ]; }

        { _args = [ "${mod} + SHIFT + 1" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 1, follow = true })'') ]; }
        { _args = [ "${mod} + SHIFT + 2" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 2, follow = true })'') ]; }
        { _args = [ "${mod} + SHIFT + 3" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 3, follow = true })'') ]; }
        { _args = [ "${mod} + SHIFT + 4" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 4, follow = true })'') ]; }
        { _args = [ "${mod} + SHIFT + 5" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 5, follow = true })'') ]; }
        { _args = [ "${mod} + SHIFT + 6" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 6, follow = true })'') ]; }
        { _args = [ "${mod} + SHIFT + 7" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 7, follow = true })'') ]; }
        { _args = [ "${mod} + SHIFT + 8" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 8, follow = true })'') ]; }
        { _args = [ "${mod} + SHIFT + 9" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 9, follow = true })'') ]; }
        { _args = [ "${mod} + SHIFT + 0" (lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = 10, follow = true })'') ]; }

        # Hyprland control
        { _args = [ "${mod} + SHIFT + R" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprctl reload")'') ]; }
        { _args = [ "${mod} + SHIFT + E" (lib.generators.mkLuaInline ''hl.dsp.exit()'') ]; }
        # (wiki warns uwsm users against `exit`; consider instead:
        #  (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("uwsm stop")''))

        # "${mod} TAB, L, hyprexpo:expo, select" (needs the hyprexpo plugin)

        # Enter resize submap
        { _args = [ "${mod} + R" (lib.generators.mkLuaInline ''hl.dsp.submap("resize")'') ]; }

        # Brightness
        { _args = [ "XF86MonBrightnessUp" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl set 15%+")'') ]; }
        { _args = [ "XF86MonBrightnessDown" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl set 15%-")'') ]; }

        # Volume
        { _args = [ "XF86AudioRaiseVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%")'') ]; }
        { _args = [ "XF86AudioLowerVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%")'') ]; }
        { _args = [ "XF86AudioMute" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle")'') ]; }

        # Media
        { _args = [ "XF86AudioPlay" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl play-pause")'') ]; }
        { _args = [ "XF86AudioStop" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl stop")'') ]; }
        { _args = [ "XF86AudioNext" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl next")'') ]; }
        { _args = [ "XF86AudioPrev" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl previous")'') ]; }
      ];

      # exec-once — both still disabled, as before:
      ##color## hl.on("hyprland.start", function() hl.exec_cmd("hyprpaper") end)
      # TODO: could these autostart apps be systemd things
      # hl.on("hyprland.start", function() hl.exec_cmd("ashell") end)

      # was extraConfig — submaps are first-class in lua now
      define_submap = {
        _args = [
          "resize"
          (lib.generators.mkLuaInline ''
            function()
              hl.bind("h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
              hl.bind("l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
              hl.bind("k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
              hl.bind("j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
              hl.bind("return", hl.dsp.submap("reset"))
              hl.bind("escape", hl.dsp.submap("reset"))
            end
          '')
        ];
      };
    };

    plugins = [
      # TODO: Worth configuring if i have a status bar?
      #pkgs.hyprlandPlugins.hyprbars
    ];
  };
}
