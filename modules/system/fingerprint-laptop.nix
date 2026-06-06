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
}
