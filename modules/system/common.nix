{
  pkgs,
  hermes-agent,
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
  #canon # Added via nixpkgs overlay
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
  codex
  opencode
  nixfmt
  python314
  quartoMinimal
  direnv
  qtcreator
  android-tools
  gcc
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
  kdePackages.okular

  # BROWSERS
  #firefoxpwa
  qutebrowser
  nyxt
  brave
  chromium

  # AUDIO
  pulseaudio
  pavucontrol
  easyeffects
  roomeqwizard

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
  #gnumeric
  obsidian
  doing
  anki-bin

  # LIBRARIES
  hunspell
  hunspellDicts.en_US

  # funsies :) heehee
  cbonsai
  # asciiquarium

  # SCHOOL
  # mathematica # https://www.balderholst.com/how-to/install-mathematica-on-nixos/
  slack-cli
  slack
  #positron-bin

  # DESKTOP ENV
  ashell
  hyprland
  lightdm
  i3
  wf-recorder
  proton-vpn
  osu-lazer-bin
  home-manager
  ollama
  docker-compose
  thunar
  hyprshot
  remmina # Maybe this should go in a different catagory
  tigervnc
  bluez
  bluez-tools
  bluetui

  # LLM
  hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop
  llama-cpp

]
