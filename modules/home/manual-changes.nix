{pkgs, ...}:
{
  home.file = {
    "rofi-config" = {
      source = "./rofi/config.rasi";
  };
  }
}
