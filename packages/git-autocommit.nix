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
      systemctl --user restart nixos-autopush.timer
      ${pkgs.libnotify}/bin/notify-send "NixOS" "Build successful. Pushing in 1 hour"
    else
      git restore .
    fi
  '';
}
