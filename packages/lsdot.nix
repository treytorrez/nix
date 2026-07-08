# packages/lsdot.nix
{ pkgs }:

pkgs.writeShellApplication {
  name = "lsdot";
  runtimeInputs = [ pkgs.coreutils ];
  text = ''
    if [ -t 1 ]; then
      h=$(${pkgs.coreutils}/bin/ls -d .[!.]* ..?* "$@" 2>/dev/null | ${pkgs.coreutils}/bin/tr '\n' ' ')
      [ -n "$h" ] && printf '\033[90m%s\033[0m\n' "$h"
    fi
    ${pkgs.coreutils}/bin/ls -FGA -I ".*" --color=auto "$@"
  '';
}