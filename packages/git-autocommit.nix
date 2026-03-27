# packages/git-autocommit.nix
{ pkgs }:
pkgs.writeShellApplication {
  name = "update";
  runtimeInputs = [ pkgs.git pkgs.libnotify ];
  text = ''
    echo "building for $(hostname)"
    cd /etc/nixos
    git add .
    if nixos-rebuild switch --flake ".#$(hostname)"; then
      git commit -m "successful build $(date '+%Y-%m-%d %H:%M')"
      systemctl --user restart nixos-autopush.timer
      notify-send "System build successful. Pushing changes in one hour"
    else
      git restore .
    fi
  '';
}
