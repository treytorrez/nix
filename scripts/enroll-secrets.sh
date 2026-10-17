#!/usr/bin/env bash
# scripts/enroll-secrets.sh
#
# One-shot local enrollment: collects secrets straight into sops on this
# machine. Nothing is echoed to the terminal, nothing is passed as a
# command-line arg, nothing touches an LLM — values go straight from
# stdin/scrapers into an age-encrypted secrets/common.yaml.
#
# Run once per repo (from any machine that can decrypt it), then rebuild.
# Needs sops in PATH (already a system package) and sudo (for the shadow hash).
set -euo pipefail
cd /etc/nixos

echo "== Secret enrollment: values are never echoed or logged =="
if ! command -v sops >/dev/null; then
  echo "sops not found in PATH" >&2; exit 1
fi

TMP=$(mktemp /tmp/enroll-secrets-XXXXXX.yaml)
chmod 600 "$TMP"
trap 'rm -f "$TMP"' EXIT

# 1. Computer password — hash scraped straight from /etc/shadow.
HASH=$(sudo getent shadow treyt | cut -d: -f2)
[ -n "$HASH" ] || { echo "could not read password hash" >&2; exit 1; }
printf 'user-password-hash: "%s"\n' "$HASH" > "$TMP"

# 2. Tailscale — reusable auth key, max 90-day expiry (rotate it, see SECRETS.md).
read -rsp 'Tailscale reusable auth key (input hidden): ' TS_KEY; echo
[ -n "$TS_KEY" ] || { echo "tailscale key required" >&2; exit 1; }
printf 'tailscale-key: "%s"\n' "$TS_KEY" >> "$TMP"

# 3. OpenRouter — reuse the decrypted key if this machine has one.
if [ -r /run/secrets/openrouter-key ]; then
  OR_KEY=$(cat /run/secrets/openrouter-key)
  read -rp "Reuse OpenRouter key from /run/secrets/openrouter-key? [Y/n] " A
  if [ "${A:-y}" = "n" ]; then
    read -rsp '  OpenRouter API key (input hidden): ' OR_KEY; echo
  fi
else
  read -rsp 'OpenRouter API key (input hidden): ' OR_KEY; echo
fi
printf 'openrouter-key: "%s"\n' "$OR_KEY" >> "$TMP"

# 4. WiFi networks — SSID + PSK per network, blank name to finish.
#    Name is just a label: home -> HOME_SSID/HOME_PSK in the env file.
echo
echo "WiFi networks:"
while true; do
  read -rp "Network name (blank to finish): " NAME
  [ -n "$NAME" ] || break
  read -rp "  SSID: " SSID
  read -rsp "  PSK (input hidden): " PSK; echo
  printf '%s_SSID: "%s"\n%s_PSK: "%s"\n' \
    "${NAME^^}" "$SSID" "${NAME^^}" "$PSK" >> "$TMP"
done

# 5. Encrypt under .sops.yaml creation_rules, then move into the repo.
sops encrypt --in-place "$TMP"
mv "$TMP" secrets/common.yaml
trap - EXIT
echo "wrote encrypted secrets/common.yaml — run 'update' to rebuild and commit."