{ config, pkgs, ... }:

let
  colors = config.lib.stylix.colors;
in {
  stylix = {
    enable = true;
    polarity = "dark";
    # Switch themes and Nyxt follows automatically:
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };

  programs.nyxt.enable = true;

  xdg.configFile."nyxt/config.lisp".text = ''
    ;; Dynamic Nyxt theme — follows Stylix base16 palette
    (define-configuration browser
      ((theme
        (make-instance 'theme:theme
                       :dark-p t
                       :background-color "${colors.base00}"     ;; bg
                       :on-background-color "${colors.base05}"  ;; fg
                       :primary-color "${colors.base0D}"        ;; blue
                       :on-primary-color "${colors.base00}"
                       :secondary-color "${colors.base03}"      ;; comment/dim
                       :on-secondary-color "${colors.base05}"
                       :accent-color "${colors.base0B}"         ;; green
                       :on-accent-color "${colors.base00}"
                       :action-color "${colors.base0D}"         ;; blue
                       :warning-color "${colors.base0A}"        ;; yellow
                       :success-color "${colors.base0B}"        ;; green
                       :highlight-color "${colors.base0E}"      ;; purple
                       :codeblock-color "${colors.base01}")))
  '';
}
