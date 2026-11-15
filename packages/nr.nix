# packages/nr.nix
#
# nr — `nix run`, but reachable from a menu.
#
# `nix shell nixpkgs#foo` drops you into an interactive shell, which needs a
# TTY. Launched from mew-run/rofi there is no TTY, so that shell exits
# instantly and silently. `nix run` doesn't need a TTY: it execs the program
# itself, so it works identically from a terminal and from a launcher.
#
#   nr firefox              -> nix run nixpkgs#firefox
#   nr firefox -- -private  -> args are forwarded to the app
#   nr nixpkgs#foo          -> explicit flake ref
#   nr .#mytool             -> anything containing # : / is taken as a ref
#
# In a terminal this is a strict superset of `nix run nixpkgs#$1 "$@"`: it
# `exec`s nix, so stdin/stdout/stderr, signals, job control, exit codes and
# PATH are exactly what a bare `nix run` gives you. No runtimeInputs are used
# on purpose — prepending packages to PATH would leak into the app.
{ pkgs }:

pkgs.writeShellApplication {
  name = "nr";
  text = ''
    usage() {
      printf 'usage: nr <program|flake-ref> [args...]\n' >&2
      exit 2
    }

    case ''${1-} in
      "" | -h | --help) usage ;;
    esac

    prog=$1
    shift

    # `nr foo -- args` (the old shell function's spelling) keeps working; the
    # separator is implicit here because we always insert our own.
    if [[ ''${1-} == "--" ]]; then
      shift
    fi

    case $prog in
      *'#'* | *:* | */*) ref=$prog ;; # already a flake ref
      *) ref="nixpkgs#$prog" ;;
    esac

    # Any of the three standard streams is a terminal => a human is watching,
    # so behave exactly like plain `nix run` (this also covers
    # `nr foo >log` and `2>&1 | tee`, where only stderr or stdout is a tty).
    if [[ -t 0 || -t 1 || -t 2 ]]; then
      exec nix run "$ref" -- "$@"
    fi

    # No terminal anywhere (mew-run/rofi): nix's errors would go nowhere, so
    # show them in a notification instead of failing invisibly. Only stderr is
    # captured; the app's stdout still goes wherever it was pointed.
    err=$(${pkgs.coreutils}/bin/mktemp)
    trap '${pkgs.coreutils}/bin/rm -f "$err"' EXIT
    if ! nix run "$ref" -- "$@" 2>"$err"; then
      ${pkgs.libnotify}/bin/notify-send -a nr "nr: $prog failed" \
        "$(${pkgs.coreutils}/bin/tail -n 8 "$err")" || true
      exit 1
    fi
  '';
}
