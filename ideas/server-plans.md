# Plans for the Server
`- [!]` means undecided

## Core
### Tailscale
Allows for secure interconnection
- Eventually want to move to headscale to keep things self-contained
    - Will I lose Mullvad exit routes?
- Store Tailscale credentials with nix sops??
    - Is this possible and will continuous verification be needed?

### Nix Build Server
- I have two old & slow nix hosts that could use a dedicated build server
- Ideally with cached builds for devices that share software
    - Is this just built in when a device build all the software?
- My needs are likely not great enough for something as big as cachix
    - [discusses some alternatives; nix-serve seems sufficient at first glance](https://www.reddit.com/r/NixOS/comments/1ry3h0j/best_choice_for_self_host_cache_like_cachix_or/)

## Media
### Immich
- is there a Nix derivation for this
- Does the software cost money
- how do I move files from G Photos with confidence??

### Music
- Jellyfin 12 offers some media functionality
- iPod
    - sync collection to iPod when plugged in via shell script (or something more robust)
    - avoids syncing over internet 
    - more selection of music management software
    - Rockbox integration would be nice
    - no streaming

- Android app
    - store media on server and stream it to phone??
    - Don't know if possible

### Self-Hosted Media/Movies
- Prooobably `Jellyfin`, opensource, free, now supports ebooks
    - NOTE: `TRaSH Guides` should be followed for episode/movie storage/naming (not sure, just read that it is a *very* good idea to do this before you screw up your library )
- Kind of contingent on getting tailscale going
- Not the best at music storage and streaming
    - separate solution for music (and files)
- Aquisitiono
    - [!] Sonarr/Radarr + some torrent

### Podcasts
- Most likely, same solution as music
- acquisition could be different

### Books 
- [!] Kavita seems like best option

## File Hosting
- Find a nice way to do this; good frontend
    - Make my own???
- 24tb available once I get SAS drive enclosure
- Files should live here and be accessible 
- Tags are more or less needed
- Able to upload/download files to/from certain locations on disk
- Browse files without all of them being downloaded to device
- Option to keep some of them downloaded to device would be very nice
- Prefer to have a solution that connects the filesystem so that I don't have to download a file to my device and then upload it again having to mess with copies and such; similar to onedrive/Google Drive sync desktop apps
- Shared editing not a big concern

- Syncthing
    - some files shuold be syncronized among all hosts (laptop, desktop, maybe android?)
    - includes 

## Calendar
- Able to sync with many clients (need more info on calendar protocols
- Sharing events?? ( might need domain name ) 

## Backups
- Delta oriented backups are preferred
- Snapshots either at a set time or when data shifts by some threshold as not to overload storage space
- Linux laptop/desktop
    - Files from home directory
    - Nix system derivation and backups
    - Maybe a store for git repos I don't want to constantly hold on system
- Phone
    - Android compatibility needed
    - iPhone compatibility preferred
    - Store list of installed apps
    - Back up files in selected/all folders accessible
    - Prefer to install the service with an app

- macOS/windows/other 
    - [!] time machine for macOS?
        - [Seems to be a good guide](https://alexlubbock.com/time-machine-network-backup-linux)
    - [!] Windows native option (want to ensure best backups)

## Budgeting
- `actual` seems to be the best here
- Live data ( maybe not to the second, but live enough )
- encrypted/secure

    ### Actual on NixOS
    The [install docs](https://actualbudget.org/docs/install) don't mention NixOS, but nixpkgs ships both an `actual-server` package and an official NixOS module (`nixos/modules/services/web-apps/actual.nix`, available in 26.05 and 25.11). The native module is the best option:

    ```nix
    services.actual = {
      enable = true;
      openFirewall = true;
      settings = {
        hostname = "0.0.0.0";
        port = 5006;
      };
    };
    ```

    Then `nixos-rebuild switch` and open `http://<host>:5006` to set the server password.

    - Module default port is **3000**; the docs/Docker use **5006**. Either works, just be consistent.
    - If putting Caddy/nginx in front, use `openFirewall = false` and `hostname = "127.0.0.1"`.
    - Secrets can go through `settings.<key>._secret = "/run/secrets/..."` so they never hit the Nix store.

    **Why this over the documented options:**
    - Declarative: service, user, data dir, and firewall live in `configuration.nix`
    - Module supplies a hardened systemd unit (`DynamicUser`, `StateDirectory`, `ProtectSystem = strict`, empty `CapabilityBoundingSet`, etc.)
    - Updates are just rebuilds with rollback, no `docker pull` drift or `npm update -g`
    - No Docker or Node toolchain needed on the host; nixpkgs builds and caches it

    **Other options:**
    - Docker: only if I need upstream `latest`/`nightly` tags faster than nixpkgs, or already run everything in containers. On NixOS prefer `virtualisation.oci-containers` over a hand-run compose file.
    - Server CLI (npm): worst fit. Global npm installs are imperative and fight the read-only store.
    - Build from source: unnecessary unless contributing; large JS build.
    - PikaPods / Fly.io: cloud hosting, ignores the NixOS box.
    - Desktop app: not the server. AppImage is awkward on NixOS; just use the browser.

    **Caveats:**
    - Version is pinned to nixpkgs (currently 26.10.0); track `nixos-unstable` or override `services.actual.package` for day-one releases
    - Data lives in `/var/lib/actual` (`server-files/` has `account.sqlite` with the hashed password/session token; `user-files/` has the budget blobs) -- back this up
    - Don't change `dataDir` after it's working; it's tied to `StateDirectory` and can break startup
    - `hostname` defaults to `::` (all interfaces), so expose it deliberately
    - Module is community-maintained, not from the Actual team, so module bugs go to nixpkgs

## Personal Website / Blog
- `nginx`
- Simple HTML and JS; prob avoid frameworks for now

## XMPP Server
- Difficulty unknown, self hosting might not be worth
- `Prosody` probably??
- Really only meant for personal use and maybe close friends
- avoids having to trust third party account providers



## Extras
### Time/NTP Server
- good for community
- needs to be able to go offline or not take much compute; this is a personal machine

### Freenet node

### Yggdrasil node
- not super sure how I would use this as of now
