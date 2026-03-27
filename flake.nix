{
  description = "Trey's NixOS configuration (flakes)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      voxtype,
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
              home-manager.extraSpecialArgs = { inherit nixcord voxtype; };
              home-manager.sharedModules = [ voxtype.homeManagerModules.default ];
              nixpkgs.overlays = [
                (final: prev: {
                  canon = final.callPackage ./packages/canon.nix { canonSrc = inputs.canonSrc; };
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
