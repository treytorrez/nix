{ pkgs, lib, ... }:
{
  home-manager.users.treyt =
    { lib, ... }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.librewolf;
        nativeMessagingHosts = [
          pkgs.tridactyl-native
          pkgs.firefoxpwa
        ];
        profiles = {
          default = {
            bookmarks = {
              force = true;
              settings = [
                {
                  name = "Nix";
                  toolbar = true;
                  bookmarks = [
                    {
                      name = "Nixpkgs Repo";
                      url = "https://github.com/NixOS/nixpkgs";
                    }
                    {
                      name = "Home Manager Manual";
                      url = "https://nix-community.github.io/home-manager/options.xhtml";
                    }
                    {
                      name = "NixOS Package Search";
                      url = "https://search.nixos.org/packages";
                    }
                  ];
                }
                {
                  name = "BYUI";
                  toolbar = true;
                  bookmarks = [
                    {
                      name = "Canvas";
                      url = "https://byui.instructure.edu";
                    }
                    {
                      name = "My BYUI";
                      url = "https://my.byui.edu";
                    }
                  ];
                }
              ];
            };
          };
          school = {
            id = 1;
            bookmarks = { };

          };
          work = {
            id = 2;
            bookmarks = { };
          };
          pwas = {
            id = 3;

          };
        };
      };
      # EXPERIMENTAL
      # firefoxpwa expects a binary named "firefox" in its runtime directory.
      # Rather than letting it download its own Firefox, I point it at our
      # Nix-managed LibreWolf binary instead. We use an activation script
      # (runs on every rebuild) rather than home.file because I only need
      # a single symlink inside the directory, not the whole thing read-only.
      home.activation.firefoxpwaRuntime = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $HOME/.local/share/firefoxpwa/runtime
        ln -sf ${pkgs.librewolf}/lib/librewolf/librewolf \
          $HOME/.local/share/firefoxpwa/runtime/firefox
      '';

    };

  environment.etc."librewolf/policies/policies.json".text = builtins.toJSON {
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
        # imagus
        "{00000f2a-7cde-4f20-83ed-434fcb420d71}" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/3547888/imagus-0.9.8.74.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        # sideberry
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4688454/sidebery-5.5.0.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
      engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" ];
        };

        "NixOS Wiki" = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nw" ];
        };
      };
    };

  };
}
