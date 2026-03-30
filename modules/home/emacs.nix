{ pkgs, ... }:
{
programs.emacs = {
  enable = true;
  package = pkgs.emacs;  # replace with pkgs.emacs-gtk if desired
  extraPackages = epkgs: [
    epkgs.nix-mode
    epkgs.nixfmt
  ];
  extraConfig = ''
    (setq standard-indent 2)
  '';
};
}
