{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # TERMINALS
    kitty
    foot
    st

    # SHELLS
    zsh
    bash

    # SHELL UTILITIES
    tmux
    zellij
    curl
    wget
    ripgrep
    ripgrep-all
    starship
    bat
    pciutils
    yazi
    btop
    fzf
    gnumake
    zip
    unzip
    (import ../../packages/new-nix-shell.nix { inherit pkgs; })
    (import ../../packages/git-autocommit.nix { inherit pkgs; })
    gh
    canon # Added via nixpkgs overlay
    figlet
    pandoc
    fwupd
    p7zip
    tabiew

    # EDITORS
    neovim
    emacs
    nano
    neovide

    # DEVELOPMENT
    git
    uv
    arduino-ide
    arduino
    codex
    opencode
    nixfmt

    # LAUNCHERS
    tofi
    wofi
    wmenu

    # MEDIA
    mpv
    tidal-hifi
    high-tide
    feh
    sxiv
    zoom-us
    pinta

    # BROWSERS
    firefoxpwa
    qutebrowser

    # AUDIO
    pulseaudio
    pavucontrol
    easyeffects

    # SYSTEM UTILS
    wlr-randr
    brightnessctl
    wl-clipboard
    xclip
    clipmenu
    mouseless
    webcamoid
    wev
    evtest
    libnotify

    # PRODUCTIVITY
    libreoffice-qt6-fresh
    protonmail-desktop
    gnumeric
    obsidian

    # LIBRARIES
    hunspell
    hunspellDicts.en_US


    # funsies :) heehee
    cbonsai
    # asciiquarium

    protonvpn-gui
    osu-lazer-bin
    home-manager
    hyprland
    lightdm
    i3
  ];
}
