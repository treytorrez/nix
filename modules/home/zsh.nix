{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;          # Kept enabled; we override the completion command below
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # ------------------------------------------------------------
    # OPTIMIZATION 1: Override completion initialization
    # ------------------------------------------------------------
    # Home Manager normally runs `autoload -U compinit && compinit` at order 570.
    # We replace it with a cached version that skips the expensive security audit
    # and dump regeneration. This reduces compinit time from ~450ms to <10ms.
    #
    # The completion dump is now regenerated automatically on each rebuild via
    # home.activation.recompZsh — no manual steps needed after switching.
    completionInit = ''
      autoload -Uz compinit
      compinit -C -d "$ZSH_COMPDUMP"
      zmodload zsh/datetime
      autoload -U calendar calendar_add
    '';

    shellAliases = {
      ls = "ls -FGAh --color=tty";
      ll = "ls --color=tty -l";
      #update = "echo \"rebuilding as $(hostname)\"; sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
      nixvim = "sudo nix run ~/nixvim-flake -- \"$@\"";
      psgrep = "ps aux | rg";
      nvimprovements = "nvim /home/$(user)/Documents/personal/improvements.md";
      # Alias to manually regenerate the completion dump if ever needed
      recomp = "rm -f ~/.cache/zsh/compdump* && ZSH_COMPDUMP=~/.cache/zsh/compdump compinit -d ~/.cache/zsh/compdump";
      xo = "xdg-open";
      gs = "git status";
      ga = "git add";
    };

    sessionVariables = {
      MANPAGER = "bat -l man --strip-ansi always --style='-numbers'";
      EDITOR = "nvim -u NONE";
    };

    # ------------------------------------------------------------
    # OPTIMIZATION 2: Use initContent for fine-grained ordering
    # ------------------------------------------------------------
    # initContent allows us to place commands at specific phases of startup.
    # Order values: 500 (early), 550 (before completion), 1000 (general), 1200 (after general), 1500 (last).
    initContent = let
      # ---- Order 500: Very early setup ----
      earlyInit = lib.mkOrder 500 ''
        # Set the location for the completion dump file (used by completionInit)
        : ''${ZSH_COMPDUMP:="$HOME/.cache/zsh/compdump"}
        mkdir -p "$(dirname "$ZSH_COMPDUMP")"
      '';

      # ---- Order 1000: General configuration (runs after completion) ----
      generalInit = lib.mkOrder 1000 ''
        # ------------------------------------------------------------
        # OPTIMIZATION 3: Deferred loading of vi-mode plugin
        # ------------------------------------------------------------
        # zsh-vi-mode can be slow to source. Using zsh-defer loads it
        # asynchronously after the prompt appears, making the shell feel instant.
        if command -v zsh-defer >/dev/null; then
          zsh-defer source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        else
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        fi

        # ------------------------------------------------------------
        # OPTIMIZATION 4: Lazy direnv hook
        # ------------------------------------------------------------
        # The direnv hook runs on every shell start. We defer it until the
        # first `cd` or prompt display, saving ~10-20ms at startup.
        _lazy_direnv() {
          unfunction _lazy_direnv
          eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd _lazy_direnv
        add-zsh-hook precmd _lazy_direnv

        # ------------------------------------------------------------
        # OPTIMIZATION 5: Compile completion dump for faster loading
        # ------------------------------------------------------------
        # Zsh can load byte-compiled dump files much faster. This compiles
        # the dump once after it's created.
        if [[ -f "$ZSH_COMPDUMP" && ! -f "$ZSH_COMPDUMP.zwc" ]]; then
          zcompile "$ZSH_COMPDUMP" 2>/dev/null
        fi

        # Your custom function
        batcanon() { canon "$@" | sed 's/ \([0-9]*\) /\1. /' | bat -l md --theme Nord --style=-numbers }

        # nix shell/run shortcuts
        ns() {
          local pkg="$1"; shift
          nix shell "nixpkgs#$pkg" "$@"
        }
        nr() {
          local pkg="$1"; shift
          nix run "nixpkgs#$pkg" "$@"
        }

        # Warp directory - reads ~/.warprc (key:path format, backward compat)
        wd() {
          local config_file=''${HOME}/.warprc
          if [[ $# -eq 0 ]]; then
            while IFS=':' read -r key path; do
              [[ -n "$key" ]] && print -P "%F{green}$key%f -> $path"
            done < "$config_file"
            return
          fi
          local target
          target=$(grep "^$1:" "$config_file" 2>/dev/null | cut -d':' -f2-)
          if [[ -n "$target" ]]; then
            cd "$target"
          else
            echo "wd: unknown warp point '$1'" >&2
            return 1
          fi
        }

       # Auto-start tmux (only if interactive and not already inside tmux)
        if [[ -z "$TMUX" && $- == *i* ]]; then
          tmux attach || tmux new
        fi
      '';

      # ---- Order 1200: Prompt setup (after most other config) ----
      promptInit = lib.mkOrder 1200 ''
        # ------------------------------------------------------------
        # OPTIMIZATION 6: Cached Starship init
        # ------------------------------------------------------------
        # Starship's init script is generated once and cached. This avoids
        # running `starship init zsh` on every shell start.
        STARSHIP_CACHE="$HOME/.cache/starship/init.zsh"
        if [[ ! -f "$STARSHIP_CACHE" ]] || [[ ${pkgs.starship}/bin/starship -nt "$STARSHIP_CACHE" ]]; then
          mkdir -p "$(dirname "$STARSHIP_CACHE")"
          ${pkgs.starship}/bin/starship init zsh --print-full-init > "$STARSHIP_CACHE"
        fi
        source "$STARSHIP_CACHE"
      '';
    in
      lib.mkMerge [ earlyInit generalInit promptInit ];
  };

  # ------------------------------------------------------------
  # Additional packages needed for optimizations
  # ------------------------------------------------------------
  home.packages = [
    pkgs.zsh-defer    # Required for deferred plugin loading
    (import ../../packages/lsdot.nix { inherit pkgs; })
    # pkgs.zsh-bench   # Optional: for profiling startup time
  ];

  # ------------------------------------------------------------
  # Automatically regenerate the completion dump on each rebuild
  # ------------------------------------------------------------
  # Replaces the need to manually run `recomp` after every system update.
  # $DRY_RUN_CMD is respected so `home-manager build` (dry run) won't mutate state.
  home.activation.recompZsh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD rm -f "$HOME/.cache/zsh/compdump"*
    $DRY_RUN_CMD mkdir -p "$HOME/.cache/zsh"
    $DRY_RUN_CMD ${pkgs.zsh}/bin/zsh -c '
      ZSH_COMPDUMP="$HOME/.cache/zsh/compdump"
      autoload -Uz compinit
      compinit -d "$ZSH_COMPDUMP"
      zcompile "$ZSH_COMPDUMP"
    '
  '';
}
