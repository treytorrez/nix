{
  description = "Trey's NixOS configuration (flakes)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      # url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of Nixvim.
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
    };  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixcord,
      canonSrc,
#      ferrite,
      voxtype,
      nixvim,
      ...
    }:
    let
      system = "x86_64-linux";
      mkHost =
        hostname:
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
              home-manager.sharedModules = [ voxtype.homeManagerModules.default nixvim.homeModules.nixvim ];
              nixpkgs.overlays = [
                (final: prev: {
                  canon = final.callPackage ./packages/canon.nix { canonSrc = inputs.canonSrc; };
                  nixvim = inputs.nixvim.packages.${final.system}.default;
                })
              ];
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        laptop = mkHost "laptop";
        desktop = mkHost "desktop";
      };
    };
}
