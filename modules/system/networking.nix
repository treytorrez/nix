{ ... }:
{
  # hostname is set per-host in hosts/<name>/default.nix
  networking = {
    networkmanager.enable = true;
    hosts = {
      "localhost:1234" = [ "chat.local" ];
    };

  };
}
