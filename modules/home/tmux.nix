{ pkgs, ... }: {
  home.packages = [ pkgs.acpi ];

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [ tmux-fzf ];

    extraConfig = ''
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
