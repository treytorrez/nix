{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.atkinson-hyperlegible-mono
    ];
    fontconfig.defaultFonts = {
      monospace = [ "AtkynsonMono Nerd Font" ];
    };
  };
}
