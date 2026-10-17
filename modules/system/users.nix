{ pkgs, config, ... }:
{
  users.users.treyt = {
    isNormalUser = true;
    description = "Trey Torrez";
    # Login/sudo password from sops (neededForUsers decrypts it before
    # users are created). mutableUsers stays true: root console can still
    # reset the password if decryption ever fails on a new host.
    hashedPasswordFile = config.sops.secrets."user-password-hash".path;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
    packages = with pkgs; [ kdePackages.kate ];
    shell = pkgs.zsh;
  };
  security.sudo.extraRules = [{
    users = [ "treyt" ];
    commands = [{
     command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
      options = [ "NOPASSWD" ];
    }];
  }];
}
