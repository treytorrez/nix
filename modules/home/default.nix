{ nixcord, ... }:
{
  imports = [
    nixcord.homeModules.nixcord
    ./firefoxpwa.nix
    #./neovim.nix
    ./nixvim.nix
    ./nixcord.nix
    ./zsh.nix
    ./starship.nix
    ./vscode.nix
    ./kitty.nix
    ./canon.nix
    ./voxtype.nix
    ./i3.nix
    ./i3status-rust.nix
    ./lxqt.nix
    ./xdg.nix
    ./emacs.nix
    ./direnv.nix
    ./ollama.nix
    ./systemd.nix
    #./positron.nix
  ];

  home.packages = [ ];
  home.stateVersion = "25.11";
}
