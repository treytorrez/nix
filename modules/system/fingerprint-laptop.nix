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

  # pam_fprintd defaults to a 30s timeout, which leaves the sensor armed (and
  # its green LED lit) for half a minute after every sudo/polkit prompt. Three
  # seconds is enough to touch the reader, then it falls through to the
  # password.
  security.pam.services.sudo.rules.auth.fprintd.settings.timeout = 3;

  # Deliberately no RuntimeMaxSec: fprintd already exits ~30s after the last
  # client, and systemd killing it mid-auth leaves the Goodix 550a armed, so
  # its LED stays green until the USB device is reset.
}
