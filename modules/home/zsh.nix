{ config, lib, pkgs, ... }:
{
  home.packages = [ pkgs.zsh-defer ];   # required for deferred vi-mode

  programs.zsh = {
    enable = true;
    enableCompletion = true;      # sets up completion paths, but we handle compinit manually
    zprof.enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # Lightweight plugins that load normally
    plugins = [
      {
        name = "wd";
        src = pkgs.zsh-wd;
        file = "share/wd/wd.plugin.zsh";
        completions = [ "share/zsh/site-functions" ];
      }
    ];

    shellAliases = {
      ls = "ls -FG --color=tty";
      ll = "ls --color=tty -l";
      nixvim = "sudo nix run ~/nixvim-flake -- \"$@\"";
      psgrep = "ps aux | rg";
      nvimprovements = "nvim /home/USER/Documents/personal/improvements.md";
    };

    sessionVariables = {
      MANPAGER = "bat -l man --strip-ansi always --style='-numbers'";
      EDITOR = "nvim -u NONE";
    };

    # Use initContent with explicit ordering
    initContent = let
      # Order 500 – very early (before anything else)
      earlyInit = lib.mkOrder 500 ''
        # Set up ZSH_COMPDUMP location if not already set
        : ''${ZSH_COMPDUMP:="$HOME/.cache/zsh/compdump"}
        mkdir -p "$(dirname "$ZSH_COMPDUMP")"
      '';

      # Order 550 – before completion initialization (replaces initExtraBeforeComp)
      beforeCompInit = lib.mkOrder 550 ''
        # Cached compinit – skip security checks if dump is fresh (<24h old)
        autoload -Uz compinit
        if [[ -n ''${ZSH_COMPDUMP}(#qN.mh-24) ]]; then
          compinit -C -d "$ZSH_COMPDUMP"
        else
          compinit -d "$ZSH_COMPDUMP"
        fi
      '';

      # Order 1000 – default (general configuration)
      generalInit = lib.mkOrder 1000 ''
        # ---- Deferred loading of vi-mode (uses zsh-defer) ----
        if command -v zsh-defer >/dev/null; then
          zsh-defer source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        else
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        fi

        # ---- Lazy direnv hook (only loads on first cd/prompt) ----
        _lazy_direnv() {
          unfunction _lazy_direnv
          eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd _lazy_direnv
        add-zsh-hook precmd _lazy_direnv

        # ---- Custom functions ----
        batcanon() { canon "$@" | sed 's/ \([0-9]*\) /\1. /' | bat -l md --theme Nord --style=-numbers }

        # ---- Auto-start tmux (only if interactive and not already in tmux) ----
        # if [[ -z "$TMUX" && $- == *i* ]]; then
          # tmux attach 2>/dev/null || tmux new
        # fi
	# Compile completion dump if it's new and not already compiled
        if [[ -f "$ZSH_COMPDUMP" && ! -f "$ZSH_COMPDUMP.zwc" ]]; then
          zcompile "$ZSH_COMPDUMP"
        fi
      '';

      # Order 1200 – after default, before "last" (e.g., prompt setup)
      promptInit = lib.mkOrder 1200 ''
        # ---- Starship prompt (cached) ----
        STARSHIP_CACHE="$HOME/.cache/starship/init.zsh"
        if [[ ! -f "$STARSHIP_CACHE" ]] || [[ ${pkgs.starship}/bin/starship -nt "$STARSHIP_CACHE" ]]; then
          mkdir -p "$(dirname "$STARSHIP_CACHE")"
          ${pkgs.starship}/bin/starship init zsh --print-full-init > "$STARSHIP_CACHE"
        fi
        source "$STARSHIP_CACHE"
      '';

    in lib.mkMerge [ earlyInit beforeCompInit generalInit promptInit ];
  };
}
