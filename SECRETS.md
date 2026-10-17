# Secrets (`sops-nix`)

Secrets in `secrets/*.yaml` are encrypted with age keys listed in `.sops.yaml` and decrypted at activation to `/run/secrets/<name>`.

## Common Operations

```bash
# Edit or create a secret
sops secrets/<name>.yaml

# Re-key all secrets after editing .sops.yaml
for f in secrets/*.yaml; do sops updatekeys "$f"; done

# Derive a host's age public key from its SSH host key
 nix shell nixpkgs#ssh-to-age -c ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
```

## Active Secrets

| File | Key | Used By |
|---|---|---|
| `secrets/openrouter.yaml` | `openrouter-key` | `laptop`, `server` (`modules/home/llm.nix`) |
| `secrets/searxng.yaml` | `searxng-secret` | `server` (`modules/system/searxng.nix`) |
| `secrets/open-webui.yaml` | `OPEN-WEBUI-SECRET-KEY` | currently unused |

## Wiring a Secret in Nix

```nix
sops.secrets."my-secret" = {
  sopsFile = ../../secrets/mysecret.yaml;
  owner = "treyt"; # optional
};
# Decrypted path: config.sops.secrets."my-secret".path (/run/secrets/my-secret)
```
