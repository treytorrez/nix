{ pkgs, ... }:
{
  users.users.treyt = {
    isNormalUser = true;
    description = "Trey Torrez";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ kdePackages.kate ];
    shell = pkgs.zsh;
  };
}
