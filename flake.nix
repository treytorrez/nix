# =============================================================================
# NixOS Flake Configuration
# =============================================================================
#   Hosts: laptop, server, desktop (NixOS) + mobile (nix-on-droid)
#   Secrets: sops-nix
#   User config: home-manager
#   Theming: stylix
# =============================================================================

{
  description = "Trey's NixOS configuration (flakes)";

  # ---------------------------------------------------------------------------
  # INPUTS
  # ---------------------------------------------------------------------------
nixConfig = {
  extra-substituters = [ "https://noctalia.cachix.org" ];
  extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
};
  inputs = {
    # --- Nixpkgs channels ----------------------------------------------------
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # --- AI / Agents ---------------------------------------------------------
    noctalia = {
      url = "github:noctalia-dev/noctalia/";
    };
    hermes-agent.url = "github:NousResearch/hermes-agent";

    # --- User environment ----------------------------------------------------
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Theming -------------------------------------------------------------
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Mobile --------------------------------------------------------------
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Editors -------------------------------------------------------------
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Apps / Packages -----------------------------------------------------
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcraft = {
      url = "github:loystonpais/nixcraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    voxtype = {
      url = "github:peteonrails/voxtype";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Secrets -------------------------------------------------------------
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- Non-flake sources ---------------------------------------------------
    canonSrc = {
      url = "github:pgattic/canon";
      flake = false;
    };
  };

  # ---------------------------------------------------------------------------
  # OUTPUTS
  # ---------------------------------------------------------------------------
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      stylix,
      nix-on-droid,
      nixcord,
      canonSrc,
      hermes-agent,
      voxtype,
      nixvim,
      sops-nix,
      noctalia,
      ...
    }:
    let
      # -----------------------------------------------------------------------
      # mkHost — create a NixOS configuration for a given hostname + system
      # -----------------------------------------------------------------------
      mkHost =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname hermes-agent noctalia; };

          modules = [
            # Host-specific configuration
            ./hosts/${hostname}

            # System-wide modules
            hermes-agent.nixosModules.default
            stylix.nixosModules.stylix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager

            # Home-manager + overlay setup
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit nixcord voxtype nixvim; };
              home-manager.sharedModules = [
                voxtype.homeManagerModules.default
                inputs.noctalia.homeModules.default
                nixvim.homeModules.nixvim
              ];

              nixpkgs.overlays = [
                # Custom packages
                (final: prev: {
                  canon = final.callPackage ./packages/canon.nix { canonSrc = inputs.canonSrc; };
                  nixvim = inputs.nixvim.packages.${final.system}.default;
                })
                # Third-party overlays
                inputs.emacs-overlay.overlays.default
              ];
            }
          ];
        };

      # -----------------------------------------------------------------------
      # mkDroid — create a nix-on-droid configuration for a given hostname
      # -----------------------------------------------------------------------
      mkDroid =
        hostname:
        nix-on-droid.lib.nixOnDroidConfiguration {
          pkgs = import nixpkgs { system = "aarch64-linux"; };
          modules = [
            ./hosts/${hostname}
            stylix.nixOnDroidModules.stylix
          ];
        };
    in
    {
      # --- NixOS machines ----------------------------------------------------
      nixosConfigurations = {
        laptop = mkHost "laptop" "x86_64-linux";
        server = mkHost "server" "x86_64-linux";
        desktop = mkHost "desktop" "x86_64-linux";
      };

      # --- Android (nix-on-droid) -------------------------------------------
      nixOnDroidConfigurations = {
        mobile = mkDroid "mobile";
      };
    };
}
