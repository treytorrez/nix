{ config, lib, pkgs, ... }:
{
  home.packages = [ pkgs.zsh-defer ];   # required for deferred vi-mode

  programs.zsh = {
    enable = true;
    enableCompletion = true;      # sets up completion paths, but we handle compinit manually
    #zprof.enable = true;
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
	  earlyInit = lib.mkOrder 500 ''
	    # Set dump location and ensure directory exists
	    : ''${ZSH_COMPDUMP:="$HOME/.cache/zsh/compdump"}
	    mkdir -p "$(dirname "$ZSH_COMPDUMP")"

	    # Optionally trim fpath (uncomment if you want aggressive pruning)
	    # fpath=(
	    #   ${pkgs.zsh}/share/zsh/${pkgs.zsh.version}/functions
	    #   ${pkgs.zsh}/share/zsh/site-functions
	    #   ${config.home.profileDirectory}/share/zsh/site-functions
	    #   $HOME/.zsh/plugins/wd/share/zsh/site-functions
	    #   $fpath
	    # )
	    # typeset -U fpath
	  '';

	  beforeCompInit = lib.mkOrder 550 ''
	    autoload -Uz compinit
	    # Always use cache; skip security; no dump regeneration
	    compinit -C -d "$ZSH_COMPDUMP"
	  '';

	  generalInit = lib.mkOrder 1000 ''
	    # ---- Deferred vi-mode ----
	    if command -v zsh-defer >/dev/null; then
	      zsh-defer source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
	    else
	      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
	    fi

	    # ---- Lazy direnv ----
	    _lazy_direnv() {
	      unfunction _lazy_direnv
	      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
	    }
	    autoload -Uz add-zsh-hook
	    add-zsh-hook chpwd _lazy_direnv
	    add-zsh-hook precmd _lazy_direnv

	    # ---- Compile completion dump for faster loading ----
	    if [[ -f "$ZSH_COMPDUMP" && ! -f "$ZSH_COMPDUMP.zwc" ]]; then
	      zcompile "$ZSH_COMPDUMP" 2>/dev/null
	    fi

	    # ---- Custom functions ----
	    batcanon() { canon "$@" | sed 's/ \([0-9]*\) /\1. /' | bat -l md --theme Nord --style=-numbers }

	    # ---- Auto-start tmux ----
#	    if [[ -z "$TMUX" && $- == *i* ]]; then
#	      tmux attach 2>/dev/null || tmux new
#	    fi
	  '';

	  promptInit = lib.mkOrder 1200 ''
	    # ---- Starship (cached) ----
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
