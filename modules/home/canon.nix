{ pkgs, ... }:
{
  home.file = {
    ".canon/texts/bom-canon".source = pkgs.callPackage ../../packages/bom-canon.nix { };
    ".canon/texts/nt-kjv-canon".source = pkgs.callPackage ../../packages/nt-kjv-canon.nix { };
    ".canon/texts/ot-kjv-canon".source = pkgs.callPackage ../../packages/ot-kjv-canon.nix { };
    ".canon/texts/pogp-canon".source = pkgs.callPackage ../../packages/pogp-canon.nix { };
    ".canon/texts/config.json".text = ''
      {
        "priority": [
          "pogp-canon",
          "ot-kjv-canon",
          "nt-kjv-canon",
          "bom-canon"
        ]
      }
    '';
  };
}
