this is super weird but I *think* I have a way to manage hashes for extensions (firefox, codium, etc ) using the flake.lock instead of manually getting the right hash for every single one
```nix
# ==================================================
# flake.nix
# ==================================================
   {
     inputs = {
       nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
       
       # Prefix with "ffext-" to identify Firefox extensions
       "ffext-uBlock0@raymondhill.net" = {
         url = "https://addons.mozilla.org/.../ublock-origin/latest.xpi";
         flake = false;
       };
       "ffext-CanvasBlocker@kkapsner.de" = {
         url = "https://addons.mozilla.org/.../4691016/latest.xpi";
         flake = false;
       };
       # ... all extensions with ffext- prefix
     };
     
     outputs = { self, nixpkgs, ... }@inputs:
     let
       # Extract all firefox extension inputs
       ffExtInputs = lib.filterAttrs 
         (name: _: lib.hasPrefix "ffext-" name) 
         inputs;
       
       # Strip prefix to get extension IDs
       ffExtensions = lib.mapAttrs' 
         (name: src: {
           name = lib.removePrefix "ffext-" name;
           value = src;
         })
         ffExtInputs;
     in {
       homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
         modules = [{
           _module.args = { inherit ffExtensions; };
         }];
       };
     };
   }
```

```nix
# ==================================================
# ./modules/home/librewolf-extensions.nix
# ==================================================
   { pkgs, lib, ffExtensions, ... }:
   let
     mkExt = id: src: settings: {
       package = pkgs.stdenv.mkDerivation {
         name = "firefox-extension-${id}";
         inherit src;
         # ... buildCommand, passthru, meta
       };
       inherit settings;
     };
     
     # Settings separate from sources (one place to define)
     allSettings = {
       "uBlock0@raymondhill.net" = { 
         permissions = [ "internal:privateBrowsingAllowed" ]; 
       };
       "CanvasBlocker@kkapsner.de" = { 
         permissions = [ "internal:privateBrowsingAllowed" ]; 
       };
     };
   in
   # Auto-generate from ALL inputs
   lib.mapAttrs 
     (id: src: mkExt id src (allSettings.${id} or {}))
     ffExtensions
```

```nix
# ==================================================
# ./modules/home/librewolf.nix
# ==================================================
   let
     exts = import ./librewolf-extensions.nix { inherit pkgs lib ffExtensions; };
   in {
     profiles.default.extensions = {
       packages = lib.mapAttrsToList (_: e: e.package) exts;
       settings = lib.mapAttrs (_: e: e.settings) exts;
     };
     
     profiles.work.extensions = {
       # Subtract tridactyl
       packages = lib.mapAttrsToList (_: e: e.package) 
         (lib.filterAttrs (id: _: id != "tridactyl.vim@cmcaine.co.uk") exts);
       settings = lib.mapAttrs (_: e: e.settings)
         (lib.filterAttrs (id: _: id != "tridactyl.vim@cmcaine.co.uk") exts);
     };
   }
```
