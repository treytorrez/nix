{ pkg, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    plugins = [
      tmuxPLugins.cpu
      tmuxPLugins.battery
}
