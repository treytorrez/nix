# Secrets (`sops-nix`)

All secrets live in `secrets/*.yaml`, age-encrypted per `.sops.yaml` (keys: `treyt`, `laptop`, `server`). At rebuild, sops-nix decrypts each declared secret to `/run/secrets/<name>`.

**No plaintext secret is ever committed. Don't hand-type secrets into these files; use `scripts/enroll-secrets.sh`.**

## Files

| File | Keys | Used by |
|---|---|---|
| `secrets/common.yaml` | `user-password-hash`, `tailscale-key`, `openrouter-key`, `<NAME>_SSID`/`<NAME>_PSK` | all hosts (`modules/system/secrets.nix`) |
| `secrets/searxng.yaml` | `searxng-secret` | `server` (`modules/system/searxng.nix`) |
| `secrets/open-webui.yaml` | `OPEN-WEBUI-SECRET-KEY` | currently unused |

## What lands where (`modules/system/secrets.nix`)

| Secret | Decrypted to | Effect |
|---|---|---|
| `user-password-hash` | `/run/secrets/user-password-hash` (before users exist, `neededForUsers`) | `users.users.treyt.hashedPasswordFile` — fresh installs boot with your existing login/sudo password. `mutableUsers` stays `true` so a root console can still reset it if sops fails |
| `tailscale-key` | `/run/secrets/tailscale-key` | `services.tailscale.authKeyFile` — `tailscaled-autoconnect` only calls `tailscale up --auth-key` when in `NeedsLogin`/`NeedsMachineAuth`, so a **reusable** key works across reboots |
| `openrouter-key` | `/run/secrets/openrouter-key` (owned `treyt`) | `modules/home/llm.nix` writes it to `~/.config/io.datasette.llm/keys.json` |
| `wifi-env` | `/run/secrets/wifi-env` (root) | env file for `networking.networkmanager.ensureProfiles` — profiles `home`/`school`/`work` reference `$HOME_SSID`/`$HOME_PSK`, etc. |

## First-time setup / rotating values

```bash
# Run on any machine that can decrypt (it also sudo-scrapes the current
# password hash from /etc/shadow and can reuse the existing OpenRouter key).
# Everything is hidden input; nothing is echoed or passed via argv.
bash scripts/enroll-secrets.sh
```

To rotate a single value later: `sops secrets/common.yaml`, edit, save, `update`.

## Tailscale key: the 90-day ritual

Auth keys max out at **90 days** (reusable included); there is no permanent key. OAuth client secrets don't expire but tag-strip device ownership — not worth it for 3 machines.

- When `tailscale up` starts failing with "auth key expired": generate a fresh reusable key (Settings → Keys, 90 days, pre-approve), `sops secrets/common.yaml`, paste it over `tailscale-key`, then `update`.
- Keys are revocable in one click from the admin console, so a leaked sops file ≠ permanent tailnet access.

## Adding a new machine

1. Install NixOS → boot → the SSH host key exists (generated on first activation).
2. Get its age key: `nix shell nixpkgs#ssh-to-age -c ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub`
3. Add it under `keys:` in `.sops.yaml` (uncomment/add `&newhost` and add it to the creation rule's key group).
4. From any enrolled machine: `for f in secrets/*.yaml; do sops updatekeys "$f"; done`, commit, pull on the new host, `update`.
5. If the very first boot fails to decrypt (rare — key generated late in activation), just reboot; host key now exists and sops-nix succeeds.
6. Tailscale/WiFi/password all self-apply; nothing typed except the repo checkout.

## Troubleshooting

- **"no matching creation rules"** — `path_regex` in `.sops.yaml` must match the file path (`secrets/[^/]+\.(yaml|json|env|ini)$`).
- **secret missing on boot** — it must be declared in Nix (`sops.secrets.<name>`) *and* present as a top-level key in the encrypted yaml; check with `sops -d`.
- **password changed but login still old** — `hashedPasswordFile` applies at activation; run `update` (a switch/reboot suffices).