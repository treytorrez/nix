{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ # TODO: slim this way down for a headless server, err on the side of leaving things
    ./hardware-configuration.nix
    ../../modules/system/boot.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/desktop.nix            # mostly not needed for headless server, could be useful if I ever need a virtual machine? best to not worry about that far ahead for now
    ../../modules/system/audio.nix
    ../../modules/system/programs.nix           # definitely needs to be parsed down eventually but these don't usually start any services or do anything but take up a little space
    ../../modules/system/packages.nix           # there was a reason i did this... maybe in a previous convo with llms
    ../../modules/system/users.nix              # shouldn't need to be deleted
    ../../modules/system/fonts.nix              # is this even useful if I use stylix? (/etc/nixos/modules/system/stylix.nix & /etc/nixos/modules/home/stylix.nix)
    ../../modules/system/focus-blacklist.nix    # can't think of any reason this stays
    ../../modules/system/focus-mode.nix         # can't think of any reason this stays
    ../../modules/system/ld.nix                 # prob keep? may not need  (ideally i wouldn't)
    ../../modules/system/tailscale.nix          # KEEP FOR NOW, will likely break so much stuff if removed. eventually migrate to headscale
    ../../modules/system/llama-server.nix       # keep! will have to fine tune for a standalone server eventually
    ../../modules/system/searxng.nix            # keep! not fully set up yet
    ../../modules/system/secrets.nix            # very much keep, needs more work for better integration
    ../../modules/system/stylix.nix             # does a server *really* need this? alternatively, would it hurt to keep? maybe builds are slower...
  ];

  networking.hostName = "server";

  nixpkgs.config.allowUnfree = true;

  home-manager.users.treyt = import ../../modules/home;
  home-manager.backupFileExtension = ".bak";

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580; # is this correct for the P6000 (i think) that's in there? should be
  };

  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };
  users.users.treyt.extraGroups = [
    "video"
    "render"
    "docker"
  ];

  # Shared secrets (password, tailscale, openrouter, wifi) come from
  # modules/system/secrets.nix; this host adds its own services' secrets.
  sops.secrets."searxng-secret".sopsFile = ../../secrets/searxng.yaml;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +10";
  };
  system.stateVersion = "26.05";
}
