{ pkgs, ... }:
{
  services.fnott = {
    enable = true;
    settings = {

      low = {
      };

      normal = {
      };

      critical = {
      };
    };
  };
}
