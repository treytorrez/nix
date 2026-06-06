# packages/git-autocommit.nix
{ pkgs }:

let
  # Capture the current date/time as a string at build time
  buildDate = builtins.unsafeDiscardStringContext (builtins.readFile (
    pkgs.runCommand "build-date" { } ''
      date +'%Y-%m-%d %H:%M:%S' > "$out"
    ''
  ));
in
pkgs.writeShellApplication {
  name = "update";
  runtimeInputs = [ pkgs.git pkgs.coreutils ];
  text = ''
    set -euo pipefail

    # Prevent running the entire script as root – sudo is used internally
    if [ "$(whoami)" = "root" ]; then
      echo "ERROR: Do not run this script with sudo. It will invoke sudo itself for nixos-rebuild." >&2
      exit 1
    fi

    HOST="$(hostname)"
    echo "Building configuration for $HOST"

    # Must be inside the NixOS config repository
    cd /etc/nixos
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
      echo "ERROR: /etc/nixos is not a git repository." >&2
      exit 1
    fi

    # Stage everything
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
      echo "Rebuild FAILED." >&2
      # Check if there is anything to stash (staged, unstaged, or untracked)
      if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
        echo "Stashing your current changes so you can recover them later..." >&2
        git stash push --include-untracked \
          -m "WIP before failed rebuild on $HOST $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Changes saved in stash. Use 'git stash list' and 'git stash pop' to retrieve them." >&2
      else
        echo "No local changes to stash." >&2
      fi
      exit 1
    fi
  '';
}
