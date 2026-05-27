{ pkgs, ... }:
{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
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
