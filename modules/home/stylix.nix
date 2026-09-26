{
  pkgs,
  config,
  ...
}:
{
  stylix.enable = true;


  #evaluation warning: treyt profile: stylix: librewolf: `config.stylix.targets.librewolf.profileNames` is not set. Declare profile names with 'config.stylix.targets.librewolf.profileNames = [ "<PROFILE_NAME>" ];'.
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
