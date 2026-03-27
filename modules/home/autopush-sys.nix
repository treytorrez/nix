systemd.user.services.nixos-autopush = {
  description = "Auto-push nixos config after idle period";
  serviceConfig = {
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
  description = "Push nixos config if idle for 1 hour";
  timerConfig = {
    OnActiveSec = "1h";
    RemainAfterElapse = false;
  };
};
