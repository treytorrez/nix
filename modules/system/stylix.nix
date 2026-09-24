{
  pkgs,
  config,
  ...
}:
{
  stylix = {
    enable = true;
    autoEnable = true;
    #config.stylix.targets.librewolf.profileNames` is not set. Declare profile
    #names with 'config.stylix.targets.librewolf.profileNames = [
    #"<PROFILE_NAME>" ];'.

    cursor = {
      package = pkgs.openzone-cursors;
      name = "OpenZone_White";
      size = 32;
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
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
