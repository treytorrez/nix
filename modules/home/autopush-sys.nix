{ pkgs, ... }:{
systemd.user.services.nixos-autopush = {
  Unit.Description = "Auto-push nixos config after idle period";
  Service = {
    Type = "oneshot";
    WorkingDirectory = "/etc/nixos";
    ExecStart = "${pkgs.writeShellScript "nixos-autopush" ''
      ${pkgs.libnotify}/bin/notify-send "NixOS Autopush" "Pushing config changes..."
      ${pkgs.git}/bin/git push
    ''}";
    Environment = "DISPLAY=:0";
  };
};

systemd.user.timers.nixos-autopush = {
  Unit.Description = "Push nixos config if idle for 1 hour";
  timerConfig = {
    OnActiveSec = "1h";
    RemainAfterElapse = false;
  };
};
}
