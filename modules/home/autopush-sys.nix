{ pkgs, ... }:{
systemd.user.services.nixos-autopush = {
  Unit.Description = "Auto-push nixos config after idle period";
  Service = {
    Type = "oneshot";
    WorkingDirectory = "/etc/nixos";
    ExecStart = "...";
    Environment = "DISPLAY=:0";
  };
};

systemd.user.timers.nixos-autopush = {
  Unit.Description = "Push nixos config if idle for 1 hour";
  Timer = {
    OnActiveSec = "1h";
    RemainAfterElapse = false;
  };
};
}
