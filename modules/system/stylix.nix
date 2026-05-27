{ pkgs, lib,  ... }:
{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/schemes/base24/gruvbox-dark.yaml";
  stylix.image = lib.fetchurl {
    url = "https://w.wallhaven.cc/full/p9/wallhaven-p9pd23.png";
    hash = "sha256-S/6kgloXiIYI0NblT6YVXfqELApbdHGsuYe6S4JoQwQ=";
  };
  stylix.fonts = {
    serif = {
      package = pkgs.nerd-fonts.atkynson-mono;
      name = "AtyknsonMono Nerd Font";
    };

    sansSerif = {
      package = pkgs.nerd-fonts.atkynson-mono;
      name = "AtyknsonMono Nerd Font";
    };

    monospace = {
      package = pkgs.nerd-fonts.atkynson-mono;
      name = "AtyknsonMono Nerd Font";
    };

    emoji = {
      package = pkgs.noto-fonts-monochrome-emoji;
      name = "Noto Monochrome Emoji";
    };
  };

}
