# /etc/nixos/modules/system/podman.nix
{ ... }:
{
virtualisation.podman = {
  enable = true;
  dockerCompat = true;       # 'docker' command points to podman
  dockerSocket.enable = true; # exposes a Docker-compatible socket
};
}
