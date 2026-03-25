{ pkgs, ... }:
{
  programs.kitty = {
    font = {
        packages = pkgs.nerd-fonts.atkynson-mono;
        name = "AtkynsonMono Nerd Font";
	size = 39;
      };
    settings = {
      shell_integration = "enabled";
    };
  };
}
