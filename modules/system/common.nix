{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
  # TERMINALS
  kitty
  foot
  st

  # SHELLS
  zsh
  plocate
  bash

  # SHELL UTILITIES
  tmux
  busybox
  delta
  aria2
  curl
  wget
  ripgrep
  ripgrep-all
  starship
  bat
  sops
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
  figlet
  pandoc
  fwupd
  p7zip
  neomutt
  mutt-wizard
  gettext
  isync
  pass
  browsh
  w3m
  croc
  gvfs
  mdr # markdown render

  # EDITORS
  neovim
  emacs
  nano
  zed-editor
  #    ferrite # Added with NixPkgs overlay

  # DEVELOPMENT
  docker
  git
  lazygit
  uv
  opencode
  pi-coding-agent
  nixfmt
  direnv
  android-tools
  gcc

  #rstudio
  #R

  # LAUNCHERS
  wmenu

  # MEDIA
  mpv
  tonearm
  feh
  zoom-us
  pinta
  mupdf
  cmus
  lucida-downloader

  # BROWSERS
  #firefoxpwa
  nyxt
  brave

  # AUDIO
  pulseaudio
  pavucontrol
  easyeffects

  # SYSTEM UTILS
  wlr-randr
  brightnessctl
  wl-clipboard
  clipmenu
  webcamoid
  wev
  evtest
  libnotify

  # PRODUCTIVITY
  libreoffice-qt
  electron-mail
  #gnumeric
  anki-bin

  # LIBRARIES
  hunspell
  hunspellDicts.en_US

  # funsies :) heehee
  cbonsai
  asciiquarium
  prismlauncher
  cowsay
  fortune
  toilet


  # SCHOOL
  # mathematica # https://www.balderholst.com/how-to/install-mathematica-on-nixos/
  slack

  # DESKTOP ENV
  hyprland
  lightdm
  wf-recorder
  proton-vpn
  proton-pass
  docker-compose
  thunar
  hyprshot
  remmina
  bluetui
  playerctl
  hyprshade
  # KDE Connect derivation comes with a service file that will auto activate.
  #kdePackages.kdeconnect-kde  
  pinentry-all
  gnupg


  # LLM
  #lilbee-bin
  tmuxai
  (llm.withPlugins{
    llm-openrouter = true;
      llm-cmd = true;
      llm-ls = true;
    llm-docs = true;
    llm-git = true;
  })
  # zram: compressed RAM swap — no disk needed (btrfs root is full anyway) and
  # avoids btrfs swapfile NOCOW/fragmentation pitfalls entirely.
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 50; # ~7GiB compressed swap on 14GiB RAM
  };

  # Built-in weekly store dedup + GC (replaces the custom home-manager
  # systemd.nix timer/service).
  nix.optimise.automatic = true;
}
