{
  pkgs,
  config,
  ...
}:
{
  stylix = {
    enable = true;
    autoEnable = true;

    # for some reason the download for themes for gnome keep failing so i simply turned it off
    # TODO: Try re-enabling this?
    #stylix.targets.gnome.enable = false;
    #config.stylix.targets.librewolf.profileNames` is not set. Declare profile
    #names with 'config.stylix.targets.librewolf.profileNames = [
    #"<PROFILE_NAME>" ];'.

    cursor = {
      package = pkgs.openzone-cursors;
      name = "OpenZone_White";
      size = 32;
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    image = ../../media/future-cubes-dark-mode.jpg;
    fonts = {
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
  };

}
