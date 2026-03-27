{ pkgs, ... }:
{
  users.users.treyt = {
    isNormalUser = true;
    description = "Trey Torrez";
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
