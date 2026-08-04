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
  croc
  gvfs

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
  sone
  feh
  zoom-us
  pinta
  kdePackages.okular
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
  ted
  protonmail-desktop
  #gnumeric
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
  osu-lazer-bin
  docker-compose
  thunar
  hyprshot
  remmina
  tigervnc
  bluetui
  playerctl
  hyprshade

  # LLM
  hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop
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
