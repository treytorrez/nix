{ pkgs, config, ... }:
{
  stylix.enable = true;

  # for some reason the download for themes for gnome keep failing so i simply turned it off
  stylix.targets.gnome.enable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  stylix.image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/p9/wallhaven-p9pd23.png";
    name = "wallhaven-p9pd23.png";
    sha256 = "sha256:036gqhbf6s5ddgvfbgn6iqbzgizssyf7820m5815b2gd748jw8zc";
  };
  stylix.fonts = {
        serif = config.stylix.fonts.monospace;
        sansSerif = config.stylix.fonts.monospace;
    #    serif = {
    #      package = pkgs.nerd-fonts.atkynson-mono;
    #      name = "AtyknsonMono NF";
    #    };
    #
    #    sansSerif = {
    #      package = pkgs.nerd-fonts.atkynson-mono;
    #      name = "AtyknsonMono Nerd Font";
    #    };

    monospace = {
      package = pkgs.nerd-fonts.atkynson-mono;
      name = "AtyknsonMono NFM";
    };

    emoji = {
      package = pkgs.noto-fonts-monochrome-emoji;
      name = "Noto Monochrome Emoji";
    };
  };


  targets.neovide = {
    enable = true;
    fonts.override.monospace = "AtyknsonMono NFM:h12";
  };

}
