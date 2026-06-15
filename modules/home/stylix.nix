{
  pkgs,
  config,
  ...
}:
{
  stylix.enable = true;

  # for some reason the download for themes for gnome keep failing so i simply turned it off
  stylix.targets.gnome.enable = false;
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
  programs.librewolf.profiles = {
    default.extensions.force = true;
    work.extensions.force = true;
    school.extensions.force = true;
    pwas.extensions.force = true;
  };

}
