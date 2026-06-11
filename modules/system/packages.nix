{ pkgs, hermes-agent, ... }:
{
  environment.systemPackages = import ./common.nix { inherit pkgs hermes-agent; };
}
