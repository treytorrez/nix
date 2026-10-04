{
  config,
  nixcord,
  pkgs,
  ...
}:
{
  imports = [
    nixcord.homeModules.nixcord
    ./librewolf.nix
    ./nixvim.nix
    ./nixcord.nix
    ./zsh.nix
    ./starship.nix
    ./kitty.nix
    ./voxtype.nix
    ./i3.nix
    ./i3status-rust.nix
    ./lxqt.nix
    ./xdg.nix
    ./emacs.nix
    ./direnv.nix
    ./systemd.nix
    ./fnott.nix
    ./mew.nix
    ./nyxt.nix
    ./hyprland.nix
    ./noctalia.nix
    ./autostart.nix
    ./foot.nix
    ./pi-coding-agent.nix
    ./tmux.nix
    ./tidal-stylix.nix
    ./llm.nix
    ./tridactyl.nix
    ./zed-editor.nix
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
