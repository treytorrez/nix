{ pkgs, ... }:
{
environment.systemPackages = import ./common.nix { inherit pkgs; };
}
