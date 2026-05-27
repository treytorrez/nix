{ pkgs, ... }:
{
  stylix.enable = true;

  # for some reason the download for themes for gnome keep failing so i simply turned it off
  stylix.targets.gnome.enable = false;
  #config.stylix.targets.librewolf.profileNames` is not set. Declare profile
  #names with 'config.stylix.targets.librewolf.profileNames = [
  #"<PROFILE_NAME>" ];'.

  stylix.targets.librewolf.profileNames = [
    "default"
    "school"
    "work"
    "pwas"
    ];

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  stylix.image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/p9/wallhaven-p9pd23.png";
    name = "wallhaven-p9pd23.png";
    sha256 = "sha256:036gqhbf6s5ddgvfbgn6iqbzgizssyf7820m5815b2gd748jw8zc";
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
