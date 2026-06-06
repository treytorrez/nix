{
  pkgs,
  config,
  ...
}:
{
  stylix.enable = true;

  # for some reason the download for themes for gnome keep failing so i simply turned it off
  stylix.targets.gnome.enable = false;
  #config.stylix.targets.librewolf.profileNames` is not set. Declare profile
  #names with 'config.stylix.targets.librewolf.profileNames = [
  #"<PROFILE_NAME>" ];'.

  stylix.targets.librewolf = {
    profileNames = [
      "default"
      #"school"
      "work"
      "pwas"
    ];
    colorTheme.enable = true;
    colors.enable = true;
    fonts.enable = true;
    inputs.enable = true;
    #colors.override.enable = true;

  };
  programs.librewolf.profiles.default.extensions.force = true;
  programs.librewolf.profiles.work.extensions.force = true;
  programs.librewolf.profiles.school.extensions.force = true;
  programs.librewolf.profiles.pwas.extensions.force = true;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  stylix.image = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/p9/wallhaven-p9pd23.png";
    name = "wallhaven-p9pd23.png";
    sha256 = "sha256:036gqhbf6s5ddgvfbgn6iqbzgizssyf7820m5815b2gd748jw8zc";
  };
  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.atkynson-mono;
      name = "AtkynsonMono NFM";
    };
    serif = config.stylix.fonts.monospace;
    sansSerif = config.stylix.fonts.monospace;

    emoji = {
      package = pkgs.noto-fonts-monochrome-emoji;
      name = "Noto Monochrome Emoji";
    };
  };

}
