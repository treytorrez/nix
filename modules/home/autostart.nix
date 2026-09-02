{ config, lib, pkgs, ... }:
{
  # ---------------------------------------------------------------------------
  # Systemd-managed autostart apps.
  #
  # These run as systemd user services that wait on the GENERIC
  # `graphical-session.target`, which uwsm provides when it starts the
  # compositor. Because they depend on the generic target (not a
  # Hyprland-specific one), they're DE/WM-agnostic: swap Hyprland for Sway
  # or Plasma and these still start once the graphical session is up.
  #
  # uwsm handles importing the compositor's environment (WAYLAND_DISPLAY,
  # DISPLAY, XDG_CURRENT_DESKTOP, etc.) into systemd/D-Bus, so these
  # services get the right env automatically.
  # ---------------------------------------------------------------------------
  systemd.user.services = {
    # NetworkManager tray applet (long-running daemon)
    nm-applet = {
      Unit = {
        Description = "NetworkManager applet";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        StartLimitIntervalSec = 60;
        StartLimitBurst = 3;
        OnFailure = [ "notify-nm-applet.service" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # EasyEffects audio effects (long-running daemon)
    easyeffects = {
      Unit = {
        Description = "EasyEffects audio effects";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        StartLimitIntervalSec = 60;
        StartLimitBurst = 3;
        OnFailure = [ "notify-easyeffects.service" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.easyeffects}/bin/easyeffects -w";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Foot terminal client — open one on login, NO restart on crash.
    # One-shot: starts once with the graphical session and stays open.
    # Note: named foot-client because programs.foot.server.enable already
    # creates a `foot` service (the foot --server daemon).
    foot-client = {
      Unit = {
        Description = "Foot terminal client";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.foot}/bin/foot";
        # No Restart = intentionally left unset (defaults to "no").
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # --- OnFailure notifiers ------------------------------------------------
    # When a service hits its start-limit and goes `failed`, systemd starts
    # its OnFailure unit, which pops a desktop notification (via fnott).
    # These are oneshot and deliberately have NO Restart/start-limit so they
    # never recurse.

    notify-nm-applet = {
      Unit.Description = "Notify nm-applet failure";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.libnotify}/bin/notify-send" + " 'nm-applet failed' 'Hit restart limit, giving up' --urgency=critical";
      };
    };

    notify-easyeffects = {
      Unit.Description = "Notify easyeffects failure";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.libnotify}/bin/notify-send" + " 'easyeffects failed' 'Hit restart limit, giving up' --urgency=critical";
      };
    };
  };
}