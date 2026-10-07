{
  config,
  lib,
  pkgs,
  ...
}:
let
  starshipInit = pkgs.runCommand "starship-init.zsh" { } ''
    ${pkgs.starship}/bin/starship init zsh --print-full-init > "$out"
    ${pkgs.zsh}/bin/zsh -n "$out"
  '';
  direnvInit = pkgs.runCommand "direnv-init.zsh" { } ''
    ${pkgs.direnv}/bin/direnv hook zsh > "$out"
    ${pkgs.zsh}/bin/zsh -n "$out"
  '';
in
{
  programs.starship.enableZshIntegration = lib.mkForce false;
  programs.direnv.enableZshIntegration = lib.mkForce false;

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Dump name re-keys when the home package set changes; otherwise rescanned
    # at most every 24h. Deferred so the first prompt paints before compinit.
    completionInit = ''
      : ''${ZSH_COMPDUMP:="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump-${builtins.unsafeDiscardStringContext (builtins.baseNameOf config.home.path)}-$ZSH_VERSION"}
      autoload -Uz compinit calendar calendar_add
      _init_completion() {
        local -A st
        zmodload -F zsh/stat b:zstat
        if [[ -s "$ZSH_COMPDUMP" ]] && zstat -H st "$ZSH_COMPDUMP" && (( st[mtime] + 86400 > EPOCHSECONDS )); then
          compinit -C -d "$ZSH_COMPDUMP"
        else
          mkdir -p "''${ZSH_COMPDUMP:h}"
          compinit -i -d "$ZSH_COMPDUMP"
          [[ ! -f "$ZSH_COMPDUMP" ]] || touch "$ZSH_COMPDUMP"
        fi
        [[ ! -s "$ZSH_COMPDUMP" || "$ZSH_COMPDUMP.zwc" -nt "$ZSH_COMPDUMP" ]] || zcompile "$ZSH_COMPDUMP"
      }
      zsh-defer -a _init_completion
    '';

    shellAliases = {
      ls = "ls -FGAh --color=tty";
      ll = "ls --color=tty -l";
      psgrep = "ps aux | rg";
      nvimprovements = "nvim /home/$USER/Documents/personal/improvements.md";
      recomp = ''rm -f -- "$ZSH_COMPDUMP" "$ZSH_COMPDUMP.zwc" && _init_completion'';
      xo = "xdg-open";
      gs = "git status";
      ga = "git add";
    };

    sessionVariables = {
      MANPAGER = "bat -l man --strip-ansi always --style='-numbers'";
      EDITOR = "nvim -u NONE";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        if [[ -o interactive && -z "$TMUX" && -t 0 && -t 1 && "$TERM" != dumb ]]; then
          # Shared window list, independent viewports: every terminal gets its
          # own session grouped with the detached "main" anchor (active window
          # is per-session, so terminals don't mirror each other). The anchor
          # costs one idle window but is never attached to directly, so tmux's
          # unconditional client-detached hook can reap per-terminal sessions
          # and windows survive all terminals closing.
          # ponytail: manually `tmux attach -t main` + detach reaps the anchor;
          # if-shell guards can't run tmux commands from hooks.
          ${pkgs.tmux}/bin/tmux has-session -t '=main' 2>/dev/null ||
            ${pkgs.tmux}/bin/tmux new-session -d -s main 2>/dev/null
          exec ${pkgs.tmux}/bin/tmux new-session -A -s "main-''${TTY##*/}" -t '=main' \; new-window
        fi
        source ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh
        zmodload zsh/datetime # EPOCHSECONDS + deja's EPOCHREALTIME
        bindkey -v
        KEYTIMEOUT=1
        # Cursor shape is the mode indicator: beam in insert, block in
        # normal/visual (DECSCUSR; tmux >=3.2 forwards it). zle init doesn't
        # fire keymap-select, so precmd pins the beam for each new prompt.
        zle-keymap-select() {
          case $KEYMAP in
            (main|viins) print -n -- '\e[6 q' ;;
            (*) print -n -- '\e[2 q' ;;
          esac
        }
        zle -N zle-keymap-select
        _vi_prompt_beam() print -n -- '\e[6 q'
        autoload -Uz add-zsh-hook
        add-zsh-hook precmd _vi_prompt_beam
        # Builtin vi delete widgets refuse to delete past the last insert-mode
        # entry point (zshzle: vi-backward-delete-char), and ^? is unbound in
        # viins by default. Bind unrestricted equivalents (vim's behavior);
        # Backspace in normal mode moves left, like vim.
        bindkey -M viins '^H' backward-delete-char
        bindkey -M viins '^?' backward-delete-char
        bindkey -M viins '^W' backward-kill-word
        bindkey -M viins '^U' backward-kill-line
        bindkey -M vicmd '^H' vi-backward-char
        bindkey -M vicmd '^?' vi-backward-char
        setopt promptsubst
        PROMPT='%F{cyan}%~%f %# '
      '')

      (lib.mkOrder 1000 ''
        source ${direnvInit}

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
            local key target
            while IFS=':' read -r key target; do
              [[ -n "$key" ]] && print -P "%F{green}$key%f -> $target"
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
      '')

      (lib.mkOrder 1500 ''
        export DEJA_HIGHLIGHT_STYLE='fg=8,blink'
        export DEJA_CYCLE_KEY="^[^I"
        _init_deja() {
          if [[ -r "$HOME/.local/share/deja/init.zsh" ]]; then
            source "$HOME/.local/share/deja/init.zsh"
          else
            eval "$(${pkgs.deja}/bin/deja init zsh)"
          fi
        }
        zsh-defer -a _init_deja
        zsh-defer -a source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        zsh-defer -a source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        if [[ "$TERM" != dumb ]]; then
          zsh-defer -12 source ${starshipInit}
        fi
        ${pkgs.toilet} --font smbraille --termwidth --gay $(${pkgs.fortune} -n 50 -s)
      '')
    ];
  };

  home.packages = [
    (import ../../packages/lsdot.nix { inherit pkgs; })
    pkgs.deja
  ];
}
