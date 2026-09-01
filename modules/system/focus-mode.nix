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
        echo "Usage: focus [start|stop|toggle|status]"
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

  # --- Web block/unblock scripts (unchanged from original) ---
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

  # Device with no GNOME stuff.
  nmcli = "${pkgs.networkmanager}/bin/nmcli";

  # Runs before focus-block-web so DNS is already pointed at unbound
  # before the blocklist is applied.
  focusDnsScript = pkgs.writeShellScript "focus-dns-engage" ''
    set -e
    # Pick the first active, non-loopback, non-tunnel connection.
    conn="$(
      ${nmcli} -t --fields NAME,DEVICE conn show --active \
        | grep -Ev ':|:(lo|tailscale[0-9]*|docker[0-9]*|veth.*)$' \
        | head -n1 | cut -d: -f1
    )"
    [ -n "$conn" ] || exit 0
    ${nmcli} connection modify "$conn" ipv4.dns 127.0.0.1 ipv4.ignore-auto-dns yes 2>/dev/null || true
    ${nmcli} -nP connection up "$conn" 2>/dev/null || true
  '';

  dnsDisengageScript = pkgs.writeShellScript "focus-dns-disengage" ''
    set -e
    # Restore DNS to whoever the network gives us (DHCP auto).
    ${nmcli} -t --fields NAME,DEVICE connection show --active |
      while IFS=: read -r name dev _; do
        echo "$dev" | grep -qE '^(lo|tail|docker|veth)' && continue
        [ -n "$name" ] || continue
        ${nmcli} connection modify "$name" ipv4.dns "" ipv4.ignore-auto-dns no 2>/dev/null || true
        ${nmcli} -nP connection up "$name" 2>/dev/null || true
      done
  '';

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

    # -------- DNS fix starts here --------
    # Root cause of the captive-portal bug: the ORIGINAL module set
    #   networking.nameservers = [ "127.0.0.1" ];
    # UNCONDITIONALLY. That stamps the whole system's DNS at unbound at
    # build/reboot time, _always_ — whether focus mode is active or not.
    # unbound ignores the DNS servers the active network hands out (e.g. a
    # captive portal's own resolver like 10.120.10.4), so on any
    # hotspot/library/portal network DNS breaks even when focus is OFF.
    #
    # Fix: do NOT rewrite the system DNS plumbing globally. Keep ordinary DNS
    # on NetworkManager (which uses each network's DHCP/DHCPv6-provided DNS),
    # and only re-point the active connection's DNS at unbound for the
    # duration of a focus session. Toggling focus on/off re-applies the
    # connection so `focus` (previously `toggle`) handles both.

    services.unbound = {
      enable = true;
      settings.remote-control.control-enable = true;
    };

    # Let wheel users toggle focus without a password prompt
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id === "org.freedesktop.systemd1.manage-units" &&
            (action.lookup("unit") === "focus-mode.target" ||
             action.lookup("unit") === "focus-block-web.service" ||
             action.lookup("unit") === "focus-dns.service") &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';

    # The master target everything hangs off
    systemd.targets.focus-mode = { description = "Focus Mode"; };

    # Re-point the active connection's DNS towards unbound while focus is on,
    # restoring auto-DNS when it is turned off.
    systemd.services.focus-dns = {
      description = "Focus mode: route DNS via unbound only while active";
      before    = [ "focus-block-web.service" ];
      partOf    = [ "focus-mode.target" ];
      wantedBy  = [ "focus-mode.target" ];
      serviceConfig = {
        Type            = "oneshot";
        RemainAfterExit = true;
        ExecStart = focusDnsScript;
        ExecStop  = dnsDisengageScript;
      };
    };

    # Web blocker — starts only with the focus target, NOT at boot
    systemd.services.focus-block-web = {
      description = "Focus mode: DNS-level web blocking";
      after    = [ "unbound.service" "focus-dns.service" ];
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

    # NOTE: do NOT add `networking.nameservers = ["127.0.0.1"]` here anymore.
    # That is what caused the DNS to break on captive portals even when focus
    # was off. Normal networking thus uses each network's own DNS, and unbound
    # only takes over while focus is active.
  };
}