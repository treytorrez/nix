{ pkgs, lib, config, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    configPath = lib.mkForce "${config.xdg.configHome}/librewolf";
    nativeMessagingHosts.packages = [
      pkgs.tridactyl-native
      pkgs.firefoxpwa
    ];
    profiles = {
      default = {
        bookmarks = {
          "Nix" = {
            toolbar = true;
            bookmarks = {
              "Nixpkgs Repo" = {
                url = "https://github.com/NixOS/nixpkgs";
              };
              "Home Manager Manual" = {
                url = "https://nix-community.github.io/home-manager/options.xhtml";
              };
              "NixOS Package Search" = {
                url = "https://search.nixos.org/packages";
              };
            };
          };
          "BYUI" = {
            toolbar = true;
            bookmarks = {
              "Canvas" = {
                url = "https://byui.instructure.edu";
              };
              "My BYUI" = {
                url = "https://my.byui.edu";
              };
            };
          };
        };
      };
      school = {
        bookmarks = { };
      };
      work = {
        bookmarks = { };
      };
      pwas = { };
    };
  };
    policies = {
      DefaultDownloadDirectory = "\${home}/Downloads";
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Canvas Blocker
        "CanvasBlocker@kkapsner.de" = {
          # NEEDS CONFIG INSIDE EXTENSION SETTINGS
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4691016/canvasblocker-1.12.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Privacy Badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4700632/privacy_badger17-2026.2.20.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # ClearURL - remove tracking info
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4432106/clearurls-1.27.3.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Multi-Account Containers
        "@testpilot-containers" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4627302/multi_account_containers-8.3.6.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Proton Pass
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4686427/proton_pass-1.34.2.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Tridactyl
        "tridactyl.vim@cmcaine.co.uk" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4704384/tridactyl_vim-1.24.5.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
}
