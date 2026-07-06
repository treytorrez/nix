{ ... }:
{
  # hostname is set per-host in hosts/<name>/default.nix
  networking = {
    networkmanager.enable = true;
    hosts = {
      "127.0.0.1:1234" = [ "chat.local" ];
    };

  };
}
