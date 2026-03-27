{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    plugins = [
      {
        name = "wd";
        src = pkgs.zsh-wd;
        file = "share/wd/wd.plugin.zsh";
        completions = [ "share/zsh/site-functions" ];
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    shellAliases = {
      ls = "ls -FG --color=tty";
      ll = "ls --color=tty -l";
      #update = "echo \"rebuilding as $(hostname)\"; sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
      nixvim = "sudo nix run ~/nixvim-flake -- \"$@\"";
      psgrep = "ps aux | rg";
    };

    sessionVariables = {
      MANPAGER = "bat -l man --strip-ansi always --style='-numbers'";
      EDITOR = "nvim -u NONE";
    };

    profileExtra = ''
      eval "$(starship init zsh)"
      batcanon() { canon "$@" | sed 's/ \([0-9]*\) /\1. /' | bat -l md --theme Nord --style=-numbers }
      tmux
    '';

  };
}
