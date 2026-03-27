# packages/git-autocommit.nix
{ pkgs }:
pkgs.writeShellApplication {
  name = "update";
  runtimeInputs = [ pkgs.git pkgs.libnotify ];
  text = ''
    echo "building for $(hostname)"
    cd /etc/nixos
    git add .
    if sudo nixos-rebuild switch --flake ".#$(hostname)"; then
      git commit -m "successful build $(date '+%Y-%m-%d %H:%M')"
      sudo -u treyt XDG_RUNTIME_DIR="/run/user/$(id -u treyt)" \
        systemctl --user restart nixos-autopush.timer
      sudo -u treyt XDG_RUNTIME_DIR="/run/user/$(id -u treyt)" \
        ${pkgs.libnotify}/bin/notify-send "NixOS" "Build successful. Pushing in 1 hour"
    else
      git restore .
    fi
  '';
}
