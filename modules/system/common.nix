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
  #    ferrite # Added with NixPkgs overlay

  # DEVELOPMENT
  piper-tts
  nodejs
  agent-browser
  docker
  python3
  git
  lazygit
  uv
  arduino-ide
  arduino
  opencode
  nixfmt
  python314
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
  chromium

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
  libreoffice-qt6-fresh
  protonmail-desktop
  electron-mail
  #gnumeric
  doing
  anki-bin

  # LIBRARIES
  hunspell
  hunspellDicts.en_US

  # funsies :) heehee
  cbonsai
  asciiquarium

  # SCHOOL
  # mathematica # https://www.balderholst.com/how-to/install-mathematica-on-nixos/
  slack
  #positron-bin

  # DESKTOP ENV
  #ashell
  hyprland
  lightdm
  i3
  wf-recorder
  proton-vpn
  proton-pass
  docker-compose
  thunar
  hyprshot
  remmina
  tigervnc
  bluetui
  playerctl
  hyprshade
  kdePackages.kdeconnect-kde  

  # LLM
  llama-cpp
  ollama
  open-webui
  tmuxai
  (llm.withPlugins{
    llm-openrouter = true;
      llm-cmd = true;
      llm-ls = true;
    llm-docs = true;
    llm-git = true;
  })

]
