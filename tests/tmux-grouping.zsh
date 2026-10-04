#!/usr/bin/env zsh
# Usage: zsh tests/tmux-grouping.zsh /nix/store/...-tmux.conf
# Verifies the grouped-session protocol zsh.nix uses + the cleanup hook in
# tmux.nix: shared window list, per-terminal active window, hook reaping.
emulate -LR zsh
setopt errexit
zmodload zsh/zpty
export TERM=${TERM:-xterm-256color}

conf=${1:A}
[[ -r $conf ]] || exit 1
sock=grp-test-$$
clientdir=$(mktemp -d)
tmux() { command tmux -L $sock -f $conf "$@" }
trap 'zpty -d 2>/dev/null; command tmux -L $sock kill-server 2>/dev/null; rm -rf -- "$clientdir"' EXIT
fail() { print -u2 "FAIL: $1"; exit 1 }

# 1. anchor + two grouped sessions, each on its own window: shared list,
#    independent active window
tmux new-session -d -s main
tmux new-session -d -s main-1 -t '=main' ';' new-window
tmux new-session -d -s main-2 -t '=main' ';' new-window
[[ $(tmux display -p -t 'main:' '#{window_index}') == 1 ]] || fail 'anchor window'
[[ $(tmux display -p -t 'main-1:' '#{window_index}') == 2 ]] || fail 'main-1 on own window'
[[ $(tmux display -p -t 'main-2:' '#{window_index}') == 3 ]] || fail 'viewports are independent'
[[ $(tmux display -p -t 'main-2:' '#{session_windows}') == 3 ]] || fail 'window list is shared'

# 2. killing a grouped session leaves the group's windows intact
tmux kill-session -t '=main-1'
tmux has-session -t '=main-2' 2>/dev/null || fail 'group survived session kill'
[[ $(tmux display -p -t 'main-2:' '#{session_windows}') == 3 ]] || fail 'windows survived session kill'

# 3. real client on a pty (the zsh.nix exec path): terminal close =>
#    client-detached hook reaps its session, spares the anchor. zpty re-evals
#    its args as a shell line, so run the client from a file to keep quoting.
cat > "$clientdir/client.zsh" <<EOF
exec tmux -L $sock -f $conf new-session -A -s main-3 -t '=main' \; new-window
EOF
zpty -b client exec zsh "$clientdir/client.zsh"   # exec: the zpty fork must not inherit the EXIT trap
for attempt in {1..50}; do
  tmux has-session -t '=main-3' 2>/dev/null && break
  sleep 0.05
done
tmux has-session -t '=main-3' 2>/dev/null || fail 'client attached'
[[ $(tmux display -p -t 'main-3:' '#{session_windows}') == 4 ]] || fail 'exec path created own window'
zpty -d client
for attempt in {1..50}; do
  tmux has-session -t '=main-3' 2>/dev/null || break
  sleep 0.05
done
tmux has-session -t '=main-3' 2>/dev/null && fail 'client-detached hook reaped the session'
tmux has-session -t '=main' 2>/dev/null || fail 'hook spared the anchor'
[[ $(tmux display -p -t 'main:' '#{session_windows}') == 4 ]] || fail 'windows intact after reap'

print -- 'tmux grouping: OK'
