# packages/new-nix-shell.nix
{ pkgs }:
pkgs.writeShellApplication {
      name = "update";
      runtimeInputs = [ pkgs.git ];
      text = ''
        cd /etc/nixos
        git add .
        if nixos-rebuild switch --flake ".#$(hostname)"; then
          git commit -m "successful build $(date '+%Y-%m-%d %H:%M')"
        else
          git restore .
        fi
      '';
    }
