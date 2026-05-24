{
  description = "Trey's NixOS configuration (flakes)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of Nixvim.
      # url = "github:nix-community/nixvim";
      url = "github:nix-community/nixvim/nixos-25.11";
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
      nix-on-droid,
      nixcord,
      canonSrc,
      #      ferrite,
      voxtype,
      nixvim,
      ...
    }:
    let
      mkHost =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}
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
              ];
            }
          ];
        };

      mkDroid =
        hostname:
        nix-on-droid.lib.nixOnDroidConfiguration {
          pkgs = import nixpkgs { system = "aarch64-linux"; };
          modules = [ ./hosts/${hostname} ];
        };
    in
    {
      nixosConfigurations = {
        laptop = mkHost "laptop" "x86_64-linux";
        desktop = mkHost "desktop" "x86_64-linux";
      };

      nixOnDroidConfigurations = {
        mobile = mkDroid "mobile";
      };
    };
}
