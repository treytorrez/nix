# NixOS Config

Multi-host NixOS flake (`laptop`, `desktop`, `server`).

## Usage

```bash
# Stages all changes, runs nixos-rebuild switch, commits on success, stashes on failure
update

# Manual rebuild
sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)

# Test shell startup & tmux grouping
zsh tests/zsh-startup.zsh
zsh tests/tmux-grouping.zsh
```

## Tools & Scripts

| Command | Source | Description |
|---|---|---|
| `update` | `packages/git-autocommit.nix` | Stage, rebuild, auto-commit (or `git stash` on failure) |
| `new-nix-shell` | `packages/new-nix-shell.nix` | `fzf` template generator for `shell.nix` |
| `lsdot` | `packages/lsdot.nix` | `ls` wrapper that dims dotfiles on a separate header line |
| `focus [on\|off\|status]` | `modules/system/focus-mode.nix` | Toggle app wrappers + Unbound DNS blocklist (`modules/system/focus-blacklist.nix`) |

## Hosts

| Host | Hardware | Notes |
|---|---|---|
| `laptop` | AMD (RX 6800S + 680M) | Daily driver, `llama-server` (ROCm pinned to dGPU), Goodix fingerprint, Podman |
| `desktop` | iMac 2013 | Broadcom `wl` WiFi, kernel pinned to `linux_7_2` |
| `server` | Dell Latitude (NVIDIA legacy 580) | `llama-server`, SearXNG, CUDA cache |

## Layout

- `flake.nix` — inputs, overlays (`emacs-overlay`, `nixvim`), `mkHost`
- `hosts/<host>/default.nix` — host-specific imports, hardware, sops, GC
- `modules/system/` — NixOS modules (`common.nix` for system packages/zram/optimise, `desktop.nix` for SDDM + Hyprland/UWSM, `llama-server.nix` for local GGUF router in `/var/lib/models`, `stylix.nix`, etc.)
- `modules/home/` — Home Manager modules imported via `modules/home/default.nix` (Hyprland, Noctalia, Foot, Kitty, Zsh, Tmux, Nixvim, Emacs, Zed, LibreWolf, `pi-coding-agent`, `llm`)
- `packages/` — custom derivations
- `secrets/` — `sops-nix` encrypted YAML files (see `SECRETS.md`)

## Local LLM (`modules/system/llama-server.nix`)

`llama-server` runs as a user service on `127.0.0.1:8080` in router mode:
- Drop GGUF models into `/var/lib/models` (or HuggingFace cache in `/var/lib/models/hf/hub`, writable by the `models` group).
- Models load on demand and unload after 5 minutes idle (`--sleep-idle-seconds 300`).
- Context is set to 32K with `q8_0` KV cache (`--ctx-size 32768 -ctk q8_0 -ctv q8_0`).
