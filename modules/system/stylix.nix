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

  stylix.cursor = {
    package = pkgs.openzone-cursors;
    name = "OpenZone_White";
    size = 32;
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  stylix.image = builtins.fetchurl {
    url = "https://cdn.discordapp.com/attachments/1273453324988846210/1524365820925317201/GirlEDM_v12_2black.png?ex=6a50cd4d&is=6a4f7bcd&hm=5b902737a2045e34bc0f06d6f047fa5b86cd3250921f8de9cc5708dee4b882ab&";
    name = "GirlEDM_v12_2black.png";
    sha256 = "sha256:0iha2hm0zdqrydhmihmn9da6c79yl4pbvm4s3pdk1rzbycm31van";
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
