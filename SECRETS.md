# Secrets Management with sops-nix

This repo uses [sops-nix](https://github.com/Mic92/sops-nix) for managing secrets.
All secrets are encrypted at rest and can be committed to git. Only machines
with the corresponding age private key can decrypt them.

## Setup (one-time per machine)

### 1. Generate your personal age key
```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

### 2. Get your public key
```bash
age-keygen -y ~/.config/sops/age/keys.txt
# Output: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx...
```

### 3. Get each host's public key
Run on each machine (laptop, server, desktop):
```bash
cat /etc/ssh/ssh_host_ed25519_key.pub | nix shell nixpkgs#ssh-to-age -c ssh-to-age
# Output: age1yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy...
```

### 4. Add your keys to `.sops.yaml`
Replace the placeholder keys in `.sops.yaml` (at repo root) with the
public keys from steps 2 and 3.

### 5. Re-key existing secrets
```bash
for f in secrets/*.yaml; do
  nix shell nixpkgs#sops -c sops updatekeys "$f"
done
```

## Editing a Secret

```bash
# Opens $EDITOR with decrypted content. Save to re-encrypt.
nix shell nixpkgs#sops -c sops secrets/<name>.yaml
```

## Available Secrets

| File | Keys | Used By |
|---|---|---|
| `secrets/openrouter.yaml` | `OPENROUTER_API_KEY` | laptop, server |
| `secrets/searxng.yaml` | `secret_key` | server |
| `secrets/hermes-env.yaml` | `HERMES_ENV` (or any env vars) | laptop, server |
| `secrets/wifi-home.yaml` | `ssid`, `psk` | laptop, desktop |
| `secrets/wifi-school.yaml` | `ssid`, `psk` | laptop |
| `secrets/wifi-work.yaml` | `ssid`, `psk` | laptop |

## How to Add a New Secret

1. Create the file: `nix shell nixpkgs#sops -c sops secrets/mysecret.yaml`
2. Add content (e.g., `my_key: my_value`) and save
3. Declare it in the relevant host's `default.nix`:
   ```nix
   sops.secrets."my-secret".sopsFile = ../../secrets/mysecret.yaml;
   ```
4. Reference it: `config.sops.secrets."my-secret".path` → `/run/secrets/my-secret`

## How It Works

- **sops** encrypts each YAML file with age keys listed in `.sops.yaml`
- At `nixos-rebuild switch` time, **sops-nix** decrypts each declared secret
  to `/run/secrets/<name>` using the host's SSH host key (or age key file)
- Services read secrets from `/run/secrets/<name>` or via templates
- Secret files are **safe to commit** — only holders of the private keys can decrypt

## Troubleshooting

**"no matching creation rules found" when editing a secret**
→ Your `.sops.yaml` doesn't have a creation_rule matching the secret file path.
Make sure `path_regex` matches `secrets/[^/]+\.(yaml|json|env|ini)$`.

**Secrets not decrypting at boot**
→ Ensure `sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]` is set
in the host config and that the SSH host key exists on the machine.

**Need to add a new machine**
→ 1. Get its age key, 2. Add to `.sops.yaml`, 3. Run `sops updatekeys` on all
secret files that the new machine needs to access, 4. Commit and rebuild.
