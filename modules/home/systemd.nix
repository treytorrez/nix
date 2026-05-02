{ pkgs, ... }:
{
  systemd.user = {
    timers."time-recording-reminder" = {
      Unit.Description = "Hourly time tracking reminder";
      Timer = {
        OnCalendar = "hourly";
        Persistent = false;
      };
      Install.WantedBy = [ "timers.target" ];
    };

    services."time-recording-reminder" = {
      Unit.Description = "Time tracking notification";
      Service = {
        Type = "oneshot";
        ExecStart =
          let
            notifyScript = pkgs.writeShellScript "time-reminder" ''
              ${pkgs.libnotify}/bin/notify-send \
                'What are you doing?' \
                'Click a button to record your activity' \
                --urgency=critical \
                --action="big-data=Now: big-data" \
                --action="procrastinating=Now: procrastinating" \
                --action="finish=Finish" \
                --wait | while read -r action; do
                  case "$action" in
                    "big-data")
                      ${pkgs.doing}/bin/doing now big-data
                      ;;
                    "procrastinating")
                      ${pkgs.doing}/bin/doing now procrastinating
                      ;;
                    "finish")
                      ${pkgs.doing}/bin/doing finish
                      ;;
                  esac
                done
            '';
          in
          "${notifyScript}";
      };
    };
  };
}
