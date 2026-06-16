{
  description = "Trey's NixOS configuration (flakes)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    hermes-agent.url = "github:NousResearch/hermes-agent";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    omnisearch = {
      url = "git+https://git.bwaaa.monster/omnisearch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of Nixvim.
      # url = "github:nix-community/nixvim";
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcraft = {
      url = "github:loystonpais/nixcraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    canonSrc = {
      url = "github:pgattic/canon";
      flake = false;
    };
    #    ferrite = { #markdown viewer
    #      url = "github:OlaProeis/Ferrite";
    #      inputs.nixpkgs.follows = "nixpkgs";
    #    };
    voxtype = {
      url = "github:peteonrails/voxtype";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

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
      #      ferrite,
      voxtype,
      nixvim,
      omnisearch,
      ...
    }:
    let
      mkHost =
        hostname: system:
        # TODO: how on god's green earth do i declare that `vimplugin-wezterm.nvim-0.5.0-unstable-2024-09-26` is allowed
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname hermes-agent; };
          modules = [
            ./hosts/${hostname}
            hermes-agent.nixosModules.default
            stylix.nixosModules.stylix
            omnisearch.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit nixcord voxtype nixvim; };
              home-manager.sharedModules = [
                voxtype.homeManagerModules.default
                nixvim.homeModules.nixvim
              ];
              nixpkgs.overlays = [
                (final: prev: {
                  canon = final.callPackage ./packages/canon.nix { canonSrc = inputs.canonSrc; };
                  nixvim = inputs.nixvim.packages.${final.system}.default;
                })
                inputs.emacs-overlay.overlays.default
              ];
            }
          ];
        };

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
      nixosConfigurations = {
        laptop = mkHost "laptop" "x86_64-linux";
        server = mkHost "server" "x86_64-linux";
        desktop = mkHost "desktop" "x86_64-linux";
      };

      nixOnDroidConfigurations = {
        mobile = mkDroid "mobile";
      };
    };
}
