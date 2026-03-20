{ nixcord, ... }:
{
  imports = [
    nixcord.homeModules.nixcord
    ./firefoxpwa.nix
    ./nixcord.nix
    ./zsh.nix
    ./starship.nix
    ./vscode.nix
    ./kitty.nix
    ./canon.nix
    ./voxtype.nix
  ];

  home.packages = [ ];
  home.stateVersion = "25.11";
}
