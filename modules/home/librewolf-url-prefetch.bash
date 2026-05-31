#!/usr/bin/env bash
declare -A urls=(
  ["uBlock0@raymondhill.net"]="https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
  ["CanvasBlocker@kkapsner.de"]="https://addons.mozilla.org/firefox/downloads/file/4691016/latest.xpi"
  ["jid1-MnnxcxisBPnSXQ@jetpack"]="https://addons.mozilla.org/firefox/downloads/file/4700632/latest.xpi"
  ["{74145f27-f039-47ce-a470-a662b129930a}"]="https://addons.mozilla.org/firefox/downloads/file/4432106/latest.xpi"
  ["@testpilot-containers"]="https://addons.mozilla.org/firefox/downloads/file/4627302/latest.xpi"
  ["78272b6fa58f4a1abaac99321d503a20@proton.me"]="https://addons.mozilla.org/firefox/downloads/file/4686427/latest.xpi"
  ["tridactyl.vim@cmcaine.co.uk"]="https://addons.mozilla.org/firefox/downloads/file/4704384/latest.xpi"
  ["90f8e9e4-6972-44bd-bb63-1f4fb47f7790"]="https://addons.mozilla.org/firefox/downloads/file/4249533/another_gruvbox_material_dark-1.0.xpi"
)

for id in "${!urls[@]}"; do
  url="${urls[$id]}"
  b32=$(nix-prefetch-url --type sha256 "$url" 2>/dev/null)
  sri=$(nix hash to-sri --type sha256 "$b32")
  echo "$id  ->  $sri"
done
