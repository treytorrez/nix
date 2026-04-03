{ pkgs, ... }:
{
# If you use home-manager, this also wires up the shell hook automatically:
programs.direnv = {
  enable = true;
  nix-direnv.enable = true;  # optional but recommended — faster nix integration
};
}
