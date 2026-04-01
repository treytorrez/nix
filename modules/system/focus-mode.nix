{ config, lib, pkgs, ... }:

let
  cfg = config.custom.focusMode;

  # --- App wrappers ---
  makeWrapper = { package, binary }:
    pkgs.writeShellScriptBin binary ''
      if systemctl is-active --quiet focus-mode.target; then
        notify-send "Focus Mode" "${binary} is blocked." 2>/dev/null || true
        echo "${binary}: blocked during focus session." >&2
        exit 1
      fi
      exec ${package}/bin/${binary} "$@"
    '';

  wrappers = map makeWrapper cfg.blockedApps;

  # --- CLI toggle command ---
  focusCli = pkgs.writeShellScriptBin "focus" ''
    notify() { notify-send "Focus Mode" "$1" -t 2000 2>/dev/null || echo "$1"; }

    case "''${1:-toggle}" in
      on)
        systemctl start focus-mode.target
        notify "ON — distractions blocked."
        ;;
      off)
        systemctl stop focus-mode.target
        notify "OFF — all systems go."
        ;;
      toggle)
        if systemctl is-active --quiet focus-mode.target; then
          systemctl stop focus-mode.target
          notify "OFF — all systems go."
        else
          systemctl start focus-mode.target
          notify "ON — distractions blocked."
        fi
        ;;
      status)
        if systemctl is-active --quiet focus-mode.target; then
          echo "focus: ON"
        else
          echo "focus: OFF"
        fi
        ;;
      *)
        echo "Usage: focus [on|off|toggle|status]"
        exit 1
        ;;
    esac
  '';

  # --- Desktop file for dmenu drun ---
  focusDesktop = pkgs.makeDesktopItem {
    name = "focus-mode";
    desktopName = "Toggle Focus Mode";
    exec = "${focusCli}/bin/focus toggle";
    icon = "preferences-system-time";
    comment = "Block distracting apps and websites";
    categories = [ "Utility" ];
    terminal = false;
  };

  # --- Web block/unblock scripts ---
  blockScript = pkgs.writeShellScript "focus-web-block" (
    lib.concatMapStrings (domain: ''
      ${pkgs.unbound}/bin/unbound-control local_zone "${domain}" always_nxdomain || true
    '') cfg.blockedDomains
  );

  unblockScript = pkgs.writeShellScript "focus-web-unblock" (
    lib.concatMapStrings (domain: ''
      ${pkgs.unbound}/bin/unbound-control local_zone_remove "${domain}" || true
    '') cfg.blockedDomains
  );

in {
  options.custom.focusMode = {
    enable = lib.mkEnableOption "focus mode";

    blockedApps = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          package = lib.mkOption { type = lib.types.package; };
          binary  = lib.mkOption { type = lib.types.str; };
        };
      });
      default = [];
      example = lib.literalExpression ''
        [ { package = pkgs.discord; binary = "discord"; } ]
      '';
    };

    blockedDomains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = [ "youtube.com" "www.youtube.com" "reddit.com" ];
    };
  };

  config = lib.mkIf cfg.enable {

    # App wrappers + CLI + desktop file
    environment.systemPackages = wrappers ++ [ focusCli focusDesktop pkgs.libnotify ];

    # Unbound as local resolver
    services.unbound = {
      enable = true;
      settings.remote-control.control-enable = true;
    };

    # Let wheel users toggle focus without a password prompt
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id === "org.freedesktop.systemd1.manage-units" &&
            (action.lookup("unit") === "focus-mode.target" ||
             action.lookup("unit") === "focus-block-web.service") &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';

    # The master target everything hangs off
    systemd.targets.focus-mode = {
      description = "Focus Mode";
    };

    # Web blocker — starts/stops with the target
    systemd.services.focus-block-web = {
      description = "Focus mode: DNS-level web blocking";
      after    = [ "unbound.service" ];
      requires = [ "unbound.service" ];
      partOf   = [ "focus-mode.target" ];
      wantedBy = [ "focus-mode.target" ];

      serviceConfig = {
        Type            = "oneshot";
        RemainAfterExit = true;
        ExecStart       = blockScript;
        ExecStop        = unblockScript;
      };
    };

    # Point system DNS to unbound
    # NOTE: if services.resolved is enabled, disable it or it will conflict:
    # services.resolved.enable = false;
    networking.nameservers = [ "127.0.0.1" ];
  };
}
