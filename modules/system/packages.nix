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
    typora
    vifm
    neomutt
    mutt-wizard
    gettext
    isync
    pass
    browsh
    w3m

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
    python314
    python313
    python313Packages.mypy
    python313Packages.ruff
    python313Packages.pdftotext
    python312
    python312Packages.mypy
    python312Packages.ruff
    python311
    python3Packages.jupytext
    quartoMinimal
    direnv
    #rstudio
    #R

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
    nyxt

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
    doing

    # LIBRARIES
    hunspell
    hunspellDicts.en_US


    # funsies :) heehee
    cbonsai
    # asciiquarium



    # SCHOOL
    # mathematica # https://www.balderholst.com/how-to/install-mathematica-on-nixos/
    sage # mathematica alternative
    slack-cli
    slack
    #positron-bin


    protonvpn-gui
    osu-lazer-bin
    home-manager
    hyprland
    lightdm
    i3
    ollama

  ];
}
