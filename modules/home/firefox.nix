{ pkgs, lib, config, ... }:
{
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;
    configPath = "${config.xdg.configHome}/librewolf/librewolf";
    nativeMessagingHosts.packages = [
      pkgs.tridactyl-native
      pkgs.firefoxpwa
    ];
    profiles = {
      default = {
        bookmarks = {
          force = true;
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
          "poop" = {
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
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4691016/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Privacy Badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4700632/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # ClearURL - remove tracking info
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4432106/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Multi-Account Containers
        "@testpilot-containers" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4627302/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Proton Pass
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4686427/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # Tridactyl
        "tridactyl.vim@cmcaine.co.uk" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4704384/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
}
