# packages/git-autocommit.nix
{ pkgs }:
pkgs.writeShellApplication {
  name = "update";
  runtimeInputs = [ pkgs.git pkgs.coreutils ];
  text = ''
    set -euo pipefail

    # Prevent running the entire script as root – sudo is used internally for rebuild
    if [ "$(whoami)" = "root" ]; then
      echo "ERROR: Do not run this script with sudo. It will invoke sudo itself for nixos-rebuild." >&2
      exit 1
    fi

    HOST="$(hostname)"
    echo "Building configuration for $HOST"

    # We must be inside the NixOS config repository
    cd /etc/nixos
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
      echo "ERROR: /etc/nixos is not a git repository." >&2
      exit 1
    fi

    # Stage everything: new, modified, and deleted files
    git add .

    if git diff --cached --quiet; then
      echo "No changes to commit – rebuilding anyway…"
    fi

    if sudo nixos-rebuild switch --flake ".#$HOST"; then
      echo "Rebuild successful."
      # Commit only when there are actually staged changes
      if ! git diff --cached --quiet; then
        git commit -m "Successful build on $HOST - $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Changes committed."
      else
        echo "No changes to commit."
      fi
    else
      echo "Rebuild FAILED. Discarding all staged and unstaged changes to tracked files (untracked files are kept)." >&2
      git reset --hard HEAD
      exit 1
    fi
  '';
}
