{ nixcord, ... }:
{
  imports = [
    nixcord.homeModules.nixcord
    ./firefox.nix
    ./nixcord.nix
    ./zsh.nix
    ./starship.nix
    ./vscode.nix
    ./kitty.nix
  ];

  home.packages = [ ];
  home.stateVersion = "25.11";
}
