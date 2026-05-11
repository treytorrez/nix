# NixOS Inference Cluster — Implementation Spec

This document instructs an agent on how to extend an existing NixOS flake to support
a distributed llama.cpp inference cluster across four machines, with Tailscale networking.

---

## Context

### Existing Repo Structure

```
├── hosts/
│   ├── desktop/          # iMac 2013, 32GB RAM, daily driver with i3
│   └── laptop/           # (existing laptop, unrelated)
├── modules/
│   ├── home/             # home-manager modules
│   └── system/           # NixOS system modules
├── packages/             # custom derivations
├── flake.nix
└── flake.lock
```

### Machines Being Added

| Hostname | Machine | RAM | GPU | Role |
|---|---|---|---|---|
| `precision` | Dell Precision 7720 | 64GB | P4000M (CUDA, sm_61) | Primary inference coordinator |
| `desktop` | iMac 2013 | 32GB | Kepler iGPU (display only, sm_3x) | RPC node + existing daily driver |
| `aspire` | Acer E5-575 | 16GB DDR4-2666 | iGPU (unused) | RPC node |
| `hp` | HP 15-r030wm | ~8GB | iGPU (unused) | Tailscale peer only; Headscale TODO |
| `s22` | Samsung S22 Ultra | 12GB (~7GB free) | Adreno 730 (Vulkan, proot-inaccessible) | RPC node, last in peer list (CPU only) |

The S22 Ultra is a **low-priority but included node.** It has 12GB RAM — after Android
overhead (~4-5GB), ~7GB is free, which is a meaningful layer contribution. It runs
Nix on Droid (proot-based Nix over Termux) and must be plugged in during inference
use due to thermal and battery constraints. It should be last in the `rpcPeers` list
so it receives the fewest layers.

---

## General Practices

- **Never destructively modify** `hosts/desktop/` — the iMac is an active daily driver.
  All inference additions must be opt-in via `imports`.
- **One concern per module.** `tailscale.nix` handles only Tailscale. `llama-rpc.nix`
  handles only the RPC server. `llama-primary.nix` handles only the coordinator.
- **Use `lib.mkOption` with defaults** for any configurable values (port, host bind
  address, number of GPU layers) so hosts can override without editing the module.
- **All new systemd services** should have `Restart = "on-failure"` and
  `After = "network.target"` at minimum.
- **No hardcoded IPs.** Use Tailscale hostnames (e.g. `precision.tail...ts.net`) or
  make addresses a module option.
- **hardware-configuration.nix** for new hosts must be generated on the actual machine
  via `nixos-generate-config`. Do not write it by hand. Leave a placeholder file with
  a comment instructing this.

### TODO Policy

**Every value that is environment-specific, unconfirmed, or requires action before
the cluster will work must have a `# TODO` comment.** The agent must not silently
leave placeholder strings or guessed values without marking them.

Use namespaced TODO tags so they are grep-able:

| Tag | Meaning |
|---|---|
| `# TODO(user):` | Requires the owner to fill in or verify |
| `# TODO(headscale):` | Blocked on self-hosted headscale setup |
| `# TODO(hardware):` | Requires generating on the physical machine |
| `# TODO(model):` | Requires a model file to be downloaded and path set |
| `# TODO(tune):` | A reasonable default is set but should be benchmarked and adjusted |
| `# TODO(network):` | Requires confirming Tailscale hostname or network detail |

**Mandatory TODO locations** — every generated file must include TODOs at minimum for:
- Any string that looks like a hostname, path, or username that the agent cannot
  know for certain (e.g. Tailscale machine names, model file paths, usernames)
- Any numeric value that is a tuning parameter (e.g. `gpuLayers`)
- Any feature that is stubbed or deferred (e.g. headscale, model download)
- The `hardware-configuration.nix` import in every new host

The agent must never write a value like `"your-domain.com"`, `"/path/to/model"`, or
`"username"` without a TODO comment on the same or preceding line explaining what
the correct value should be and how to find it.

---

## Files to Create

### 1. `modules/system/tailscale.nix`

A system-level module that enables Tailscale on any host.

**Requirements:**
- Enable `services.tailscale`
- Open the Tailscale UDP port in the firewall (`41641`)
- Accept the default managed Tailscale login server
- Include a prominent `# TODO(headscale):` block as a comment showing the alternative
  config for self-hosted headscale, including:
  - `services.tailscale.loginServer = "https://your-domain.com";`
  - A note that `services.headscale` config lives in `modules/system/headscale.nix`
  - A note that the HP (`hp` host) is the intended headscale server

Example structure:
```nix
{ ... }: {
  services.tailscale.enable = true;
  networking.firewall.allowedUDPPorts = [ 41641 ];

  # TODO(headscale): when self-hosting, set:
  # services.tailscale.loginServer = "https://your-domain.com";
  # See modules/system/headscale.nix for the server config.
  # Intended host: hp (HP 15-r030wm)
}
```

**Required TODOs in this file:**
- `# TODO(headscale):` block for the loginServer swap, as shown above

---

### 2. `modules/system/headscale.nix`

A **TODO stub** — this file should exist but contain only comments. It is not
activated by any host yet.

**Requirements:**
- The file must be valid Nix that evaluates (return an empty attrset `{ }` or
  `{ ... }: { }`)
- Include a `# TODO(headscale):` block documenting:
  - Enable `services.headscale`
  - Required options: `address`, `port`, `settings.server_url`
  - That a domain and port-forwarding are prerequisites
  - That this should be imported only by the `hp` host
  - Reference to the Headscale NixOS module docs

---

### 3. `modules/system/llama-rpc.nix`

A system module that runs `llama-rpc-server` as a systemd service. This is imported
by **all inference nodes** including the primary.

**Requirements:**
- Expose a `services.llamaRpc` option namespace with:
  - `enable` (bool, default `false`)
  - `port` (int, default `50052`)
  - `host` (string, default `"0.0.0.0"`)
- When enabled, add `pkgs.llama-cpp` to `environment.systemPackages`
- Define a systemd service `llama-rpc` that runs:
  `llama-rpc-server --host <host> --port <port>`
- Service config requirements:
  - `After = [ "network.target" "tailscaled.service" ]`
  - `Restart = "on-failure"`
  - `RestartSec = "5s"`
- Open the configured port in `networking.firewall.allowedTCPPorts`

---

### 4. `modules/system/llama-primary.nix`

A system module for the **primary inference coordinator only** (`precision`).
This is what actually runs inference, using the RPC nodes as backends.

**Requirements:**
- Expose a `services.llamaPrimary` option namespace with:
  - `enable` (bool, default `false`)
  - `rpcPeers` (list of strings, default `[]`) — list of `host:port` RPC backends
  - `gpuLayers` (int, default `20`) — number of layers to offload to P4000M
  - `model` (string, default `""`) — path to the model file
- Enable `nixpkgs.config.cudaSupport = true` when the module is enabled
- Add NVIDIA hardware config:
  ```nix
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  ```
- Include a comment noting the P4000M is Pascal (sm_61) and uses the stable
  driver, not legacy_390 or legacy_470
- Do **not** define a systemd service here — the primary is invoked manually
  or via a wrapper script. Add a comment explaining this.
- Add `pkgs.llama-cpp` to `environment.systemPackages`

**Required TODOs in this file:**
- `# TODO(tune):` on the `gpuLayers` default — 20 is a reasonable starting point
  for the P4000M's 8GB VRAM on a 70B Q4 model but should be benchmarked
- `# TODO(model):` on the `model` option — note that the path will depend on
  where the user downloads the GGUF file
- `# TODO(network):` on the `rpcPeers` option description — note that Tailscale
  hostnames must match what the machines are actually named in the Tailnet

---

### 5. `hosts/precision/default.nix`

Host config for the Dell Precision 7720.

**Requirements:**
- Import from `modules/system/`:
  - `tailscale.nix`
  - `llama-rpc.nix`
  - `llama-primary.nix`
  - Existing shared modules as appropriate (`boot.nix`, `locale.nix`,
    `networking.nix`, `users.nix`, etc.)
- Enable the modules:
  ```nix
  services.llamaRpc.enable = true;
  services.llamaPrimary = {
    enable = true;
    # TODO(tune): gpuLayers = 20 is a starting estimate for P4000M 8GB VRAM
    # with a Q4_K_M 70B model. Benchmark and adjust up or down.
    gpuLayers = 20;
    # TODO(network): confirm these match the actual Tailscale machine names.
    # Run `tailscale status` on any enrolled peer to see the assigned hostnames.
    rpcPeers = [
      "desktop.tailnet:50052"   # iMac
      "aspire.tailnet:50052"    # Acer
    ];
    # TODO(model): set this once a model is downloaded, e.g.:
    # model = "/home/<user>/models/llama-3-70b.Q4_K_M.gguf";
  };
  ```
- Include a `# TODO(headscale):` comment noting to add this host to headscale
  once self-hosting is set up
- Leave a placeholder comment for `hardware-configuration.nix` import:
  `# TODO(hardware): replace stub with output of nixos-generate-config on this machine`

**Required TODOs in this file:**
- `# TODO(user):` on `networking.hostName` — confirm the hostname matches what
  is enrolled in Tailscale
- `# TODO(user):` on any username in `users.users` — must match the actual user
- `# TODO(tune):` on `gpuLayers`
- `# TODO(network):` on each entry in `rpcPeers`
- `# TODO(model):` on the `model` path
- `# TODO(hardware):` on the hardware-configuration.nix import
- `# TODO(headscale):` noting migration away from managed Tailscale

---

### 6. `hosts/precision/hardware-configuration.nix`

**Do not write this file.** Create it as a stub:

```nix
# This file must be generated on the Dell Precision 7720 by running:
#   nixos-generate-config --show-hardware-config
# Then replace this stub with the output.
{ ... }: { }
```

---

### 7. `hosts/aspire/default.nix`

Host config for the Acer E5-575.

**Requirements:**
- Minimal NixOS config — this is a headless inference node, not a workstation
- Import: `tailscale.nix`, `llama-rpc.nix`, and minimal shared modules
  (`boot.nix`, `locale.nix`, `networking.nix`, `users.nix`)
- Enable:
  ```nix
  services.llamaRpc.enable = true;
  ```
- Include a comment noting:
  - Kaby Lake CPU has AVX2; llama.cpp will use it automatically
  - DDR4-2666 gives reasonable memory bandwidth for CPU inference
- Leave placeholder for hardware-configuration.nix import

**Required TODOs in this file:**
- `# TODO(user):` on `networking.hostName` — confirm it matches Tailscale enrollment
- `# TODO(user):` on any username in `users.users`
- `# TODO(hardware):` on the hardware-configuration.nix import

---

### 8. `hosts/aspire/hardware-configuration.nix`

Same stub pattern as `hosts/precision/hardware-configuration.nix`.

---

### 9. `hosts/hp/default.nix`

Host config for the HP 15-r030wm.

**Requirements:**
- Very minimal NixOS config — this machine only runs Tailscale
- Import: `tailscale.nix`, `headscale.nix` (the stub), and minimal shared modules
- Do **not** import any llama modules
- Include a warning comment:
  - Bay Trail Celeron — may have 32-bit UEFI; verify boot mode before installing
  - Too weak for inference; intentionally excluded from RPC cluster
- Include a `# TODO(headscale):` block noting this is the intended headscale host:
  ```nix
  # TODO(headscale): when self-hosting coordination:
  # 1. Obtain a domain and configure port forwarding on your router
  # 2. Uncomment and configure modules/system/headscale.nix
  # 3. Import it here
  # 4. Remove managed Tailscale and set loginServer to your domain
  ```

**Required TODOs in this file:**
- `# TODO(user):` on `networking.hostName`
- `# TODO(user):` on any username in `users.users`
- `# TODO(hardware):` on the hardware-configuration.nix import — additionally
  note the 32-bit UEFI risk: verify with `bootctl status` or check BIOS before
  attempting NixOS install
- `# TODO(headscale):` full migration block as shown above

---

### 10. `hosts/hp/hardware-configuration.nix`

Same stub pattern. Add an additional comment about the 32-bit UEFI risk.

---

### 11. `hosts/desktop/default.nix` — MODIFY CAREFULLY

The iMac is an existing daily driver. **Additive changes only.**

**Requirements:**
- Add to the existing imports list (do not replace anything):
  - `../../modules/system/tailscale.nix`
  - `../../modules/system/llama-rpc.nix`
- Add to the existing config body:
  ```nix
  services.llamaRpc.enable = true;
  ```
- Do not touch i3, home-manager, or any other existing configuration
- Add a comment above the new imports:
  ```nix
  # --- inference cluster additions ---
  ```

- Add a GPU notice comment near the top of the config body:
  ```nix
  # NOTE: iMac 2013 GPU is Kepler (sm_3x) — below llama.cpp CUDA minimum (sm_50).
  # GPU is used for display only via legacy_470 driver. Do not attempt CUDA here.
  # This host contributes CPU compute and 32GB RAM as an RPC node only.
  ```

**Required TODOs in this file:**
- `# TODO(network):` next to the RPC enable line — note that the Tailscale
  hostname for this machine must be confirmed and added to `rpcPeers` in
  `hosts/precision/default.nix`
- `# TODO(headscale):` noting that once headscale is self-hosted, this host
  needs to re-enroll with the new login server

---

### 12. `flake.nix` — MODIFY

Add the three new hosts to `nixosConfigurations`.

**Requirements:**
- Follow the exact same pattern used for existing hosts (`desktop`, `laptop`)
- Add entries for `precision`, `aspire`, `hp`
- Each should use the same `system = "x86_64-linux"` and `specialArgs` / `modules`
  pattern already established
- Do not alter existing host entries

**Required TODOs in this file:**
- `# TODO(hardware):` next to each new host entry — note that the build will
  fail until `hardware-configuration.nix` stubs are replaced with real output
- `# TODO(user):` if `specialArgs` passes a username or other user-specific
  value that needs to be set per-host

---

### 13. S22 Ultra — Nix on Droid (No Flake File Required)

The S22 Ultra runs Nix on Droid, which is a proot-based environment — not NixOS.
It cannot be managed by the flake. Instead, document the manual setup here so it
can be reproduced.

**Do not create a host entry in the flake for this machine.**

Instead, add a file `docs/s22-rpc-setup.md` documenting:

- Install `llama-cpp` via `nix-env` or a local `shell.nix` in Nix on Droid
- Run manually:
  ```bash
  llama-rpc-server --host 0.0.0.0 --port 50052
  ```
- Enroll in Tailscale via the Tailscale Android app (not via Nix)
- Once enrolled, add its Tailscale hostname to `rpcPeers` in
  `hosts/precision/default.nix`
- CPU-only — Adreno 730 Vulkan is inaccessible from proot

**Required TODOs in this doc:**
- `# TODO(network):` — Tailscale hostname of the phone must be added to
  `rpcPeers` in `hosts/precision/default.nix` once enrolled
- `# TODO(tune):` — phone should be last in the `rpcPeers` list so it receives
  the fewest and lightest layers

---

## File Summary

| File | Action |
|---|---|
| `modules/system/tailscale.nix` | Create |
| `modules/system/headscale.nix` | Create (TODO stub) |
| `modules/system/llama-rpc.nix` | Create |
| `modules/system/llama-primary.nix` | Create |
| `hosts/precision/default.nix` | Create |
| `hosts/precision/hardware-configuration.nix` | Create (stub) |
| `hosts/aspire/default.nix` | Create |
| `hosts/aspire/hardware-configuration.nix` | Create (stub) |
| `hosts/hp/default.nix` | Create |
| `hosts/hp/hardware-configuration.nix` | Create (stub) |
| `hosts/desktop/default.nix` | Modify (additive only) |
| `flake.nix` | Modify (add new hosts) |
| `docs/s22-rpc-setup.md` | Create (manual setup doc, not a flake host) |
