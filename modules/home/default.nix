{
  config,
  nixcord,
  pkgs,
  ...
}:
{
  imports = [
    nixcord.homeModules.nixcord
    #./firefoxpwa.nix
    ./librewolf.nix
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
    #./systemd.nix
    ./fnott.nix
    ./mew.nix
    #./rofi.nix
    ./nyxt.nix
    #./positron.nix
    ./hyprland.nix
    ./noctalia.nix
    #./stylix.nix
    #./ashell.nix
    ./foot.nix
    ./tmux.nix
    ./tidal-stylix.nix
    ./llm.nix
    ./tridactyl.nix
  ];

  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.caladea
    pkgs.carlito
    pkgs.vista-fonts
    pkgs.nixd
    pkgs.nil
    pkgs.black
    pkgs.ruff
    pkgs.rust-analyzer

  ];
  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "25.11";
}
