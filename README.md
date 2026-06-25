# Trey's NixOS Flake

Declarative, multi-host NixOS configuration powering a laptop, desktop, and server — plus a Nix-on-Droid mobile setup.

## Principles

- **Simplicity** — prefer readable over clever
- **Idiomatic design** — follow Nix conventions, not workarounds
- **Declarative is best** — if it can be configured in Nix, it should be
- **Backup, backup, backup** — everything is in git, secrets are encrypted and committable

## Quickstart

```bash
# Update system (stages all changes, rebuilds, commits on success)
update

# Or manually:
sudo nixos-rebuild switch --flake .#<hostname>
```

> **Warning:** `update` stashes all changes on build failure. Run `git stash pop` to recover.

## Structure

```
.
├── flake.nix                 # Entry point — defines inputs, hosts, overlays
├── AGENTS.md                 # Instructions for AI coding assistants
├── SECRETS.md                # sops-nix secrets workflow
├── .sops.yaml                # Age key roster for secret encryption
│
├── hosts/
│   ├── laptop/               # AMD laptop — full dev setup
│   ├── desktop/              # iMac 2013 — minimal desktop
│   └── server/               # NVIDIA server — LLM server, search
│
├── modules/
│   ├── home/                 # Home-manager modules (user-level config)
│   └── system/               # NixOS system modules (global config)
│
├── packages/                 # Custom package derivations
├── secrets/                  # Encrypted secrets (safe to commit)
├── ideas/                    # Future plans & proposals
└── archive/                  # Deprecated / backup configs
```

## Machines

| Host | Hardware | Role | Highlights |
|------|----------|------|------------|
| **laptop** | AMD (ROCm) | Daily driver | Ollama, Hermes AI agent, fingerprint reader, full dev environment |
| **desktop** | iMac 2013 | Legacy desktop | Broadcom WiFi, no LLM workloads |
| **server** | NVIDIA (legacy 580) | Headless server | Ollama CUDA, Hermes, SearXNG, Docker, Tailscale |
| **mobile** | Android (aarch64) | Phone | Nix-on-Droid, minimal CLI tools |

## System Modules (`modules/system/`)

Core infrastructure shared across machines:

| Module | Purpose |
|--------|---------|
| `boot.nix` | systemd-boot, silent boot, Plymouth splash |
| `locale.nix` | America/Boise, en_US.UTF-8 |
| `networking.nix` | NetworkManager |
| `desktop.nix` | SDDM + Hyprland, LXQt session, Ozone env |
| `audio.nix` | PipeWire, ALSA, PulseAudio compat, 48kHz, 115% volume |
| `programs.nix` | Flakes, Zsh, Steam, CUPS, OpenSSH |
| `users.nix` | User `treyt`, passwordless sudo for rebuild |
| `fonts.nix` | AtkynsonMono Nerd Font as default monospace |
| `stylix.nix` | Gruvbox-dark-hard theming, wallhaven wallpaper |
| `focus-mode.nix` | Systemd-based distraction blocker (app block + DNS block) |
| `focus-blacklist.nix` | Blocked apps and domains for focus mode |
| `ld.nix` | nix-ld for running non-Nix binaries |
| `tailscale.nix` | Tailscale mesh VPN |
| `podman.nix` | Rootless containers |
| `ollama.nix` | Llama server (ROCm on laptop, CUDA on server) |
| `hermes-agent.nix` | AI agent with Ollama backend, Docker sandbox (WIP) |
| `searxng.nix` | Private meta-search engine (server only) |
| `secrets.nix` | WiFi split configuration docs |
| `fingerprint-laptop.nix` | Goodix fingerprint reader (laptop only) |

### Focus Mode

A system-wide distraction blocker. Toggle with `focus`, `focus on`, `focus off`:

- **App blocking** — systemd target wraps steam, spotify, neovide, etc. When focus is active, these apps won't launch
- **DNS blocking** — Unbound blocks youtube, reddit, twitter, facebook, instagram, twitch, nixos.org
- **Desktop entry** — clickable toggle from app launcher

## Home Modules (`modules/home/`)

Per-user configuration shared across all machines:

### Desktop & Window Management

| Module | Purpose |
|--------|---------|
| `hyprland.nix` | Wayland compositor — Vim HJKL focus/move, workspaces, media keys, smart-enter tmux-aware Super+Enter |
| `i3.nix` | Retained i3 config (commented out, for reference) |
| `ashell.nix` | Top status bar — workspaces, window title, system info, clock, volume, network, battery |
| `rofi.nix` | App launcher — drun, run, window, ssh modes |
| `dunst.nix` | Notification daemon with urgency levels |

### Terminals & Shells

| Module | Purpose |
|--------|---------|
| `foot.nix` | Minimal Wayland-native terminal (server mode) |
| `kitty.nix` | GPU-accelerated terminal with Zsh/git integration |
| `tmux.nix` | Terminal multiplexer — mouse, 24h clock, fzf integration |
| `zsh.nix` | Optimized Zsh — cached compinit, deferred vi-mode, lazy direnv, auto-start tmux |
| `starship.nix` | Two-line prompt with git, language info, timing |
| `direnv.nix` | Per-directory environment loader with nix-direnv |

### Editors & Development

| Module | Purpose |
|--------|---------|
| `nixvim.nix` | Declarative Neovim — LSP (go, python, nix, R, lua, sql), Molten notebooks, Quarto, Telescope, which-key, cmp, lazygit |
| `emacs.nix` | Emacs pgtk — Evil modal, which-key, vertico, eglot, magit, vterm, org-roam |
| `vscode.nix` | VSCode with Python, Jupyter, Neovim, ChatGPT, Data Wrangler |
| `nixcord.nix` | EquiCord (Vencord fork) for Discord with plugins |

### Browsers & Communication

| Module | Purpose |
|--------|---------|
| `librewolf.nix` | Privacy-focused Firefox fork — managed profiles, Tridactyl, uBlock, CanvasBlocker, Privacy Badger, ClearURLs, Containers, Proton Pass |
| `librewolf-extensions.nix` | 8 extensions packaged declaratively with SRI hashes |
| `nixcord.nix` | Discord client mod |

### Writing & Research

| Module | Purpose |
|--------|---------|
| `canon.nix` | Book of Mormon, Bible (KJV), Pearl of Great Price scripture texts |
| `tidal-stylix.nix` | Gruvbox-themed Tidal Hi-Fi desktop app |

### System Services

| Module | Purpose |
|--------|---------|
| `systemd.nix` | Hourly time-tracking reminder (libnotify) |
| `synthing.nix` | File sync service |
| `voxtype.nix` | Whisper-based voice typing (disabled) |
| `xdg.nix` | Custom desktop entries |

### Styling

| Module | Purpose |
|--------|---------|
| `tidal-stylix.nix` | SCSS theme compilation from Stylix color variables |
| `stylix.nix` | (Commented out) Home-level Stylix theming for LibreWolf |
| `i3status-rust.nix` | Status bar blocks with gruvbox-dark |

## Custom Packages (`packages/`)

| Package | Purpose |
|---------|---------|
| `git-autocommit.nix` | **`update`** — stages, rebuilds, commits, or stashes on failure |
| `new-nix-shell.nix` | **`new-nix-shell`** — fzf-based interactive nix shell template generator (30+ languages) |
| `canon.nix` | `canon` — Go-based scripture reference tool |
| `bom-canon.nix` | Book of Mormon text database |
| `nt-kjv-canon.nix` | New Testament (KJV) text database |
| `ot-kjv-canon.nix` | Old Testament (KJV) text database |
| `pogp-canon.nix` | Pearl of Great Price text database |
| `hypr-kinetic-scroll.nix` | Kinetic scroll plugin for Hyprland (needs hash update) |

## Secrets

Managed with [sops-nix](https://github.com/Mic92/sops-nix). See `SECRETS.md` for the full workflow.

| Secret | Contains | Used By |
|--------|----------|---------|
| `openrouter.yaml` | OpenRouter API key | laptop, server |
| `searxng.yaml` | SearXNG secret key | server |
| `hermes-env.yaml` | Hermes agent environment | laptop, server |
| `wifi-*.yaml` | WiFi credentials | laptop, desktop |

## Smart Enter Keybind

`Super+Enter` is context-aware:

- **If running inside tmux** — sends `tmux split-window` directly
- **Otherwise** — spawns a new foot terminal

## Neovim (`nixvim.nix`)

Declarative Neovim config with the following highlights:

- **Spacemacs-style leader key** (`<space>`) with which-key menus
- **LSP** — gopls, pylsp, nil, air (R), harper_ls, lua_ls, sqruff
- **Notebooks** — Molten (Jupyter kernel integration) for Python and R
- **Quarto** — preview, close, activate
- **Telescope** — find files, grep, buffers, help, recent
- **Completion** — nvim-cmp with multiple sources
- **Git** — LazyGit integration
- **`<C-w>` disabled in insert mode** — prevents accidental window navigation while typing

## Related Tools

```bash
update              # Full system update (stages, rebuilds, commits)
new-nix-shell       # Interactive language template generator
focus               # Toggle distraction blocker
canon               # Scripture reference tool
```
