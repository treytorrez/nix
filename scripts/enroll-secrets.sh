#!/usr/bin/env bash
# scripts/enroll-secrets.sh
#
# One-shot local enrollment: collects secrets straight into sops on this
# machine. Nothing is echoed to the terminal, nothing is passed as a
# command-line arg, nothing touches an LLM — values go straight from
# stdin/scrapers into an age-encrypted secrets/common.yaml.
set -euo pipefail
if [ "$(id -un)" = "root" ]; then
  echo "ERROR: run as treyt, not sudo/root — sudo is invoked internally where needed." >&2
  echo "       Run as root, the output file becomes root-owned and the final" >&2
  echo "       self-check cannot decrypt (root has no age key)." >&2
  exit 1
fi
cd /etc/nixos

echo "== Secret enrollment: values are never echoed or logged =="
if ! command -v sops >/dev/null; then
  echo "sops not found in PATH" >&2; exit 1
fi

# Must live under secrets/ so .sops.yaml path_regex (secrets/[^/]+\.yaml$) matches.
TMP=$(mktemp secrets/.enroll-secrets-XXXXXX.yaml)
chmod 600 "$TMP"
trap 'rm -f "$TMP"' EXIT

# 1. Computer password — hash scraped straight from /etc/shadow.
HASH=$(sudo getent shadow treyt | cut -d: -f2)
[ -n "$HASH" ] || { echo "could not read password hash" >&2; exit 1; }
printf "user-password-hash: '%s'\n" "$HASH" > "$TMP"

# 2. Tailscale — reusable auth key, max 90-day expiry (rotate it, see SECRETS.md).
read -rsp 'Tailscale reusable auth key (input hidden): ' TS_KEY; echo
[ -n "$TS_KEY" ] || { echo "tailscale key required" >&2; exit 1; }
printf "tailscale-key: '%s'\n" "$TS_KEY" >> "$TMP"

# 3. OpenRouter — reuse the decrypted key if this machine has one.
if sudo test -r /run/secrets/openrouter-key; then
  OR_KEY=$(sudo cat /run/secrets/openrouter-key)
  read -rp "Reuse OpenRouter key from /run/secrets/openrouter-key? [Y/n] " A
  if [ "${A:-y}" = "n" ]; then
    read -rsp '  OpenRouter API key (input hidden): ' OR_KEY; echo
  fi
else
  read -rsp 'OpenRouter API key (input hidden): ' OR_KEY; echo
fi
printf "openrouter-key: '%s'\n" "$OR_KEY" >> "$TMP"

# 4. WiFi networks — stored under the `wifi-env` key as KEY=VALUE lines for
#    systemd EnvironmentFile=/run/secrets/wifi-env.
echo
echo "WiFi networks (home / school / work — blank to finish):"
WIFI_LINES=""
while true; do
  read -rp "Network name (blank to finish): " NAME
  [ -n "$NAME" ] || break
  read -rp "  SSID: " SSID
  read -rsp "  PSK (input hidden): " PSK; echo
  WIFI_LINES+="  ${NAME^^}_SSID=${SSID}"$'\n'"  ${NAME^^}_PSK=${PSK}"$'\n'
done

if [ -n "$WIFI_LINES" ]; then
  printf "wifi-env: |\n%s" "$WIFI_LINES" >> "$TMP"
else
  printf "wifi-env: ''\n" >> "$TMP"
fi

# 5. Encrypt in place under .sops.yaml creation_rules, then move into place.
sops encrypt --in-place "$TMP"
mv "$TMP" secrets/common.yaml
trap - EXIT

# 6. Self-check: verify decrypted password hash matches live /etc/shadow hash.
DEC_HASH=$(sops -d --extract '["user-password-hash"]' secrets/common.yaml)
if [ "$DEC_HASH" != "$HASH" ]; then
  echo "ERROR: decrypted user-password-hash does not match /etc/shadow!" >&2
  exit 1
fi

echo "OK: wrote secrets/common.yaml and verified user-password-hash matches /etc/shadow."
echo "Run 'update' to rebuild and commit."
