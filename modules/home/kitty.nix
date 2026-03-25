{ pkgs, ... }:
{
  programs.kitty = {
  enable = true;
    font = {
        package = pkgs.nerd-fonts.atkynson-mono;
        name = "AtkynsonMono Nerd Font";
	size = 20;
      };
    settings = {
      shell_integration = "enabled";
    };
  };
}
