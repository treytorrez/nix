{ pkgs, ... }:
{
  services.fnott = {
    enable = true;
    settings = {
    main = { selection-helper="mew"; };

      low = {
      };

      normal = {
      };

      critical = {
      };
    };
  };
}
