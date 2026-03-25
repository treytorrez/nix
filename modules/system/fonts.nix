{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.atkynson-mono
    ];
    fontconfig.defaultFonts = {
      monospace = [ "AtkynsonMono Nerd Font" ];
    };
  };
}
