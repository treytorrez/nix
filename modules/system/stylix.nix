{
  pkgs,
  config,
  ...
}:
{
  stylix.enable = true;

  # for some reason the download for themes for gnome keep failing so i simply turned it off
  # TODO: Try re-enabling this?
  #stylix.targets.gnome.enable = false;
  #config.stylix.targets.librewolf.profileNames` is not set. Declare profile
  #names with 'config.stylix.targets.librewolf.profileNames = [
  #"<PROFILE_NAME>" ];'.

  stylix.cursor = {
    package = pkgs.openzone-cursors;
    name = "OpenZone_White";
    size = 32;
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
  stylix.image = ../../media/future-cubes-dark-mode.jpg;
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
