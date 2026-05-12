# librewolf-extensions.nix
# TODO Get the FLAKE to manage the hashes! ha HA! 
{ pkgs, lib, ... }:
let
  mkExtension =
    id: url: hash: mozPermissions:
    pkgs.stdenv.mkDerivation {
      name = "firefox-extension-${id}";
      src = pkgs.fetchurl {
        inherit url hash;
      };
      preferLocalBuild = true;
      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${id}.xpi"
      '';
      passthru.addonId = id;
      meta.mozPermissions = mozPermissions; # Add this
    };

  mkExt = id: url: hash: settings: {
    package = mkExtension id url hash (settings.permissions or [ ]); # Pass permissions
    inherit settings;
  };
in
{
  "uBlock0@raymondhill.net" =
    mkExt "uBlock0@raymondhill.net"
      "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      "sha256-8nMNKHcAV2OkXXZXSYkuk29JyucT0o96puoxRFS4nPE="
      { permissions = [ "internal:privateBrowsingAllowed" ]; };

  "CanvasBlocker@kkapsner.de" =
    mkExt "CanvasBlocker@kkapsner.de"
      "https://addons.mozilla.org/firefox/downloads/file/4691016/latest.xpi"
      "sha256-BpjZLEvS0ZCy9AJWE79L09ukCRDVirTPGzLzZjeiRMk="
      { permissions = [ "internal:privateBrowsingAllowed" ]; };

  "jid1-MnnxcxisBPnSXQ@jetpack" =
    mkExt "jid1-MnnxcxisBPnSXQ@jetpack"
      "https://addons.mozilla.org/firefox/downloads/file/4700632/latest.xpi"
      "sha256-vz3jW4RL7PFmRJ8dkn+ZSiq6+4/Ezod+ynqMbNEk00o="
      { permissions = [ "internal:privateBrowsingAllowed" ]; };

  "{74145f27-f039-47ce-a470-a662b129930a}" = # ClearURLS
    mkExt "{74145f27-f039-47ce-a470-a662b129930a}"
      "https://addons.mozilla.org/firefox/downloads/file/4432106/latest.xpi"
      "sha256-VJJrbkJ01ZNaX8DapjIPHTcePS8aWHdGfKOrIqZcTyA="
      { permissions = [ "internal:privateBrowsingAllowed" ]; };

  "@testpilot-containers" =
    mkExt "@testpilot-containers" "https://addons.mozilla.org/firefox/downloads/file/4627302/latest.xpi"
      "sha256-vz3jW4RL7PFmRJ8dkn+ZSiq6+4/Ezod+ynqMbNEk00o="
      { permissions = [ "internal:privateBrowsingAllowed" ]; };

  "78272b6fa58f4a1abaac99321d503a20@proton.me" =
    mkExt "78272b6fa58f4a1abaac99321d503a20@proton.me"
      "https://addons.mozilla.org/firefox/downloads/file/4686427/latest.xpi"
      "sha256-A7S1m7ylrLlUWclw/IPt6AxFx7W2mK/sKeUyFCOe6ns="
      { permissions = [ "internal:privateBrowsingAllowed" ]; };

  "tridactyl.vim@cmcaine.co.uk" =
    mkExt "tridactyl.vim@cmcaine.co.uk"
      "https://addons.mozilla.org/firefox/downloads/file/4704384/latest.xpi"
      "sha256-C/GMKjqO28v0bJkVSJiOxRBzSxm5XzJb63b0SEB5+wc="
      { permissions = [ "internal:privateBrowsingAllowed" ]; };

  "90f8e9e4-6972-44bd-bb63-1f4fb47f7790" =
    mkExt "90f8e9e4-6972-44bd-bb63-1f4fb47f7790"
      "https://addons.mozilla.org/firefox/downloads/file/4249533/another_gruvbox_material_dark-1.0.xpi"
      "sha256-uoZ8lgIvpX0ibaPwLMY1QEd8n8MlqwKihohx9HSfQqE="

      { permissions = [ "internal:privateBrowsingAllowed" ]; };

}
