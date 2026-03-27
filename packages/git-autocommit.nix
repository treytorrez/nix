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
    else
      git restore .
    fi
  '';
}
