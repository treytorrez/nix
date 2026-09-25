{
  pkgs,
  ...
}:
with pkgs;
[
  # TERMINALS
  kitty
  foot
  st

  # SHELLS
  zsh
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
  #canon # Added via nixpkgs overlay
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
  mdr

  # EDITORS
  neovim
  emacs
  nano
  neovide
  zed-editor
  #    ferrite # Added with NixPkgs overlay

  # DEVELOPMENT
  nodejs
  docker
  git
  lazygit
  uv
  opencode
  pi-coding-agent
  nixfmt
  direnv
  qtcreator
  android-tools
  gcc

  #rstudio
  #R

  # LAUNCHERS
  wmenu

  # MEDIA
  mpv
  tidal-hifi
  sone
  high-tide
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


  # SCHOOL
  # mathematica # https://www.balderholst.com/how-to/install-mathematica-on-nixos/
  slack
  #positron-bin

  # DESKTOP ENV
  #ashell
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
  kdePackages.kdeconnect-kde  
  oo7 # For freedesktop.secrets management
  oo7-pam
  oo7-server
  oo7-portal

  # LLM
  llama-cpp
  lilbee-bin
  ollama
  tmuxai
  (llm.withPlugins{
    llm-openrouter = true;
      llm-cmd = true;
      llm-ls = true;
    llm-docs = true;
    llm-git = true;
  })

]
