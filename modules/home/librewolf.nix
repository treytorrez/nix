{
  pkgs,
  lib,
  ...
}:
{
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;
    nativeMessagingHosts = [
      pkgs.tridactyl-native
      #pkgs.firefoxpwa
    ];
    profiles = {
      default = {
        id = 0;
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
        # EXTENSIONS ==================================================
        # TODO check extension file for hash management
        extensions =
          let
            exts = import ./librewolf-extensions.nix { inherit pkgs lib; };
          in
          {
          # extensions are packaged WITH their settings to reduce me having to type names more than once.
              packages = lib.mapAttrsToList (_: e: e.package) exts;
              settings = lib.mapAttrs (_: e: e.settings) exts;
          };
        #==============================================================

        search = {
          force = true;
          default = "Startpage";
          engines = {
            startpage = {
              name = "Startpage";
              urls = [
                {
                  template = "https://www.startpage.com/sp/search";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            nix-packages = {
              name = "Nix Packages @26.05";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
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

            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
              iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
              definedAliases = [ "@nw" ];
            };
            nix-options = {
              name = "Nix Options @26.05";
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "26.05";
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

            bing.metaData.hidden = true;
            google.metaData.hidden = true;
            #google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };

        };
        # TODO: add vertical tabs default
        # TODO: shouldn't this ↓↓ make the corners of all the buttons sharp?
        userChrome = ''
          /* no rounding!! */
          * { 
            border-radius: 0px !important;
            font-size: 25px !important;
              font-family: AtkynsonMono Nerd Font !important;
          }
        '';
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
    policies = {
      DefaultDownloadDirectory = "\${home}/Downloads";
    };
  };
}
