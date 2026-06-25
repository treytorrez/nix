{ pkgs, ... }: {
  home.packages = with pkgs; [ acpi fzf ];

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [ tmux-fzf ];

    extraConfig = ''
      # tmux-fzf: replace default ? (list-keys) with fuzzy keybinding search
      unbind ?
      unbind F
      set-environment -g TMUX_FZF_LAUNCH_KEY "?"
      set-environment -g TMUX_FZF_ORDER "session|window|pane|keybinding|command|clipboard|process"

      set -g status-interval 30
      set -g status-left-length 30
      set -g status-right-length 80

      set -g status-bg black
      set -g status-fg green

      set -g status-left "#[fg=black,bg=green] #S "

      set -g status-right "#[fg=green]Bat: #(acpi -b 2>/dev/null | cut -d, -f2 | tr -d ' ') %H:%M"

      set -g window-status-current-style fg=black,bg=green
      set -g window-status-style fg=green,bg=black
      set -g window-status-format ' #I #W '
      set -g window-status-current-format ' #I #W '

      set -g pane-border-style fg=brightblack
      set -g pane-active-border-style fg=green
    '';
  };
}
