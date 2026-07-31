{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/boot.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/desktop.nix
    ../../modules/system/audio.nix
    ../../modules/system/programs.nix
    ../../modules/system/packages.nix
    ../../modules/system/users.nix
    ../../modules/system/fonts.nix
    ../../modules/system/focus-blacklist.nix
    ../../modules/system/focus-mode.nix
    ../../modules/system/ld.nix
    ../../modules/system/tailscale.nix
    ../../modules/system/podman.nix
    ../../modules/system/ollama.nix
    ../../modules/system/fingerprint-laptop.nix
    #../../modules/system/hermes-agent.nix
    ../../modules/system/stylix.nix

  ];

  networking.hostName = "laptop";
  nixpkgs.config.allowUnfree = true;

  home-manager.users.treyt = import ../../modules/home;
  home-manager.backupFileExtension = ".bak";

  hardware = {
    bluetooth.enable = true;
    amdgpu.opencl.enable = true;
  };
  users.users.treyt.extraGroups = [
    "video"
    "render"
  ];
  security.sudo.extraRules = [{
    users = [ "treyt" ];
    commands = [{
      command = "/run/current-system/sw/bin/podman";
      options = [ "NOPASSWD" ];
    }];
  }];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "openrouter-key" = {
        sopsFile = ../../secrets/openrouter.yaml;
        owner = "treyt";
      };
      "hermes-env".sopsFile = ../../secrets/hermes-env.yaml;
    };
  };

  system.stateVersion = "26.05";
}
