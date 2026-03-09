{ config, lib, pkgs, ... }:

let
  cfg = config.programs.firefoxpwa;
in
{
  options.programs.firefoxpwa = {
    enable = lib.mkEnableOption "PWAsForFirefox";

    sites = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          manifestUrl = lib.mkOption {
            type = lib.types.str;
            description = "URL to the PWA's manifest.json";
          };
          profile = lib.mkOption {
            type = lib.types.str;
            default = "00000000000000000000000000";
            description = "Profile ID to install the PWA into";
          };
        };
      });
      default = [];
      description = "List of PWAs to install declaratively";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.firefoxpwa ];

    # Install the Firefox runtime once
    home.activation.installFirefoxPWARuntime = {
      after = ["writeBoundary"];
      before = [];
      data = ''
        if [ ! -d "$HOME/.local/share/firefoxpwa/runtime" ]; then
          echo "Installing firefoxpwa runtime..."
          ${pkgs.firefoxpwa}/bin/firefoxpwa runtime install
        fi
      '';
    };

    # Install each declared PWA, guarded so logins/profiles are preserved
    home.activation.installFirefoxPWASites = {
      after = ["installFirefoxPWARuntime"];
      before = [];
      data = ''
      ${lib.concatMapStringsSep "\n" (site: ''
        if ! ${pkgs.firefoxpwa}/bin/firefoxpwa site list 2>/dev/null | grep -qF "${site.manifestUrl}"; then
          echo "Installing PWA: ${site.manifestUrl}"
          ${pkgs.firefoxpwa}/bin/firefoxpwa site install "${site.manifestUrl}" \
            --profile "${site.profile}"
        else
          echo "PWA already installed, skipping: ${site.manifestUrl}"
        fi
      '') cfg.sites}
      '';
    };
  };
}
