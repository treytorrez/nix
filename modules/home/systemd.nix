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
        ExecStart = "${pkgs.libnotify}/bin/notify-send 'What are you doing?' -u critical";
      };
    };
  };
}
