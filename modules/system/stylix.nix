{
  pkgs,
  config,
  ...
}:
{
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    #config.stylix.targets.librewolf.profileNames` is not set. Declare profile
    #names with 'config.stylix.targets.librewolf.profileNames = [
    #"<PROFILE_NAME>" ];'.

    cursor = {
      package = pkgs.openzone-cursors;
      name = "OpenZone_White";
      size = 32;
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/darkmoss.yaml"; # TODO: need a better scheme with more actual colors, still prefer lowprofile/black/sleek styles. maybe ill just go back to gruvbox. hopefully that gruvbox wallpaper is somewhere in the repo history.
    #image = ../../media/future-cubes-dark-mode.jpg;
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
