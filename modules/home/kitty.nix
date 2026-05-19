{ pkgs, ... }:
{
  programs.kitty = {
  enable = true;
  shellIntegration.enableZshIntegration = true;
    font = {
        package = pkgs.nerd-fonts.atkynson-mono;
        name = "AtkynsonMono Nerd Font";
	size = 25;
      };
    themeFile = "gruvbox-dark-hard";
  };
}
