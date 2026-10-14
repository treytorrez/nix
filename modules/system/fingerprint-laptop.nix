{
  pkgs,
  ...
}:
{
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix-550a;
    };
  };

  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  # The ~50MB is the Goodix TOD driver + libfprint (can't shrink it), but it
  # doesn't need to be resident. dbus-activated: exits after idle, PAM
  # re-activates it instantly at login/sudo.
  systemd.services.fprintd.serviceConfig.RuntimeMaxSec = "10min";
}
