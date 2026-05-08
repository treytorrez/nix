{ pkgs, ... }:
{
  #imports = [ ./firefox.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  services.printing.enable = true;
  services.openssh.enable = true;
  documentation.man.generateCaches = true;

}
