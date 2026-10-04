#!/usr/bin/env zsh
# Usage: zsh tests/zsh-startup.zsh /nix/store/...-hm_..zshrc
emulate -LR zsh
setopt errexit
zmodload zsh/zpty

export ZSH_TEST_RC=${1:A}
[[ -r "$ZSH_TEST_RC" ]] || exit 1
sandbox=$(mktemp -d)
trap 'zpty -d 2>/dev/null; rm -rf -- "$sandbox"' EXIT
export ZDOTDIR=$sandbox ZSH_COMPDUMP=$sandbox/compdump
export ZSH_TEST_RESULT=$sandbox/result ZSH_TEST_BUFFER=$sandbox/buffer
export TMUX=startup-test TERM=xterm-256color

cat > "$sandbox/.zshrc" <<'RC'
source "$ZSH_TEST_RC"
HISTFILE=$ZDOTDIR/history

# Repro for: exit insert, re-enter insert, delete what was typed last insert.
_vi_probe() {
  BUFFER="abc" CURSOR=3
  zle vi-cmd-mode
  zle vi-insert
  zle "${$(bindkey -M viins '^?')##* }"   # whatever Backspace is bound to
  print -r -- "$BUFFER" > "$ZSH_TEST_BUFFER"
  BUFFER="" CURSOR=0
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-init _vi_probe

_check_startup() {
  local result=FAIL
  if (( ${+_comps[git]} && $+functions[_deja_precmd] &&
        $+functions[_zsh_highlight] && $+functions[prompt_starship_precmd] )) &&
     [[ -o promptsubst && -s "$ZSH_COMPDUMP.zwc" &&
        ${(M)precmd_functions:#_direnv_hook} == _direnv_hook &&
        ${(M)precmd_functions:#prompt_starship_precmd} == prompt_starship_precmd &&
        "$(bindkey -lL main)" == "bindkey -A viins main" &&
        $+functions[zle-keymap-select] &&
        "$(KEYMAP=vicmd zle-keymap-select)" == $'\e[2 q' &&
        "$(KEYMAP=main zle-keymap-select)" == $'\e[6 q' &&
        "${$(bindkey -M viins '^?')##* }" == backward-delete-char &&
        "${$(bindkey -M vicmd '^?')##* }" == vi-backward-char &&
        "$(<"$ZSH_TEST_BUFFER")" == ac ]]; then
    result=OK
  fi
  if [[ $result == FAIL ]]; then
    typeset -p precmd_functions
    print -r -- "git completion: ${_comps[git]}"
    print -r -- "viins ^?: $(bindkey -M viins '^?')"
    print -r -- "vicmd ^?: $(bindkey -M vicmd '^?')"
    print -r -- "probe buffer: $(<"$ZSH_TEST_BUFFER")"
    bindkey -lL main
    whence -w _deja_precmd _zsh_highlight prompt_starship_precmd zle-keymap-select
  fi
  print -r -- "$result" > "$ZSH_TEST_RESULT"
  exit
}
zsh-defer -a _check_startup
RC

mtime() { zstat -H st "$ZSH_COMPDUMP" && print -- "${st[mtime]}" }
zmodload -F zsh/stat b:zstat

for pass in cold warm stale; do
  if [[ $pass == stale ]]; then
    touch -d '2 days ago' "$ZSH_COMPDUMP"
    before_stale=$(mtime)
  elif [[ $pass == warm ]]; then
    before_warm=$(mtime)
  fi
  rm -f "$ZSH_TEST_RESULT"
  zpty -b shell exec zsh -d
  for attempt in {1..200}; do
    [[ ! -s "$ZSH_TEST_RESULT" ]] || break
    sleep 0.05
  done
  if [[ ! -s "$ZSH_TEST_RESULT" || "$(<"$ZSH_TEST_RESULT")" != OK ]]; then
    while zpty -r shell line; do print -r -- "$line"; done
    print -u2 -- "$pass startup failed"
    exit 1
  fi
  zpty -d shell
  if [[ $pass == warm ]]; then
    [[ $(mtime) == "$before_warm" ]] || { print -u2 'warm start regenerated the compdump (fast path broken)'; exit 1 }
  elif [[ $pass == stale ]]; then
    [[ $(mtime) != "$before_stale" ]] || { print -u2 'stale compdump was not regenerated'; exit 1 }
  fi
  print -- "$pass startup: OK"
done
