{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    enableGitIntegration = true;
    ##color##    extraConfig = ''
    ##color##      font_family      family='AtkynsonMono Nerd Font' style=Light
    ##color##      bold_font        auto
    ##color##      italic_font      family='AtkynsonMono Nerd Font' style='Light Italic'
    ##color##      bold_italic_font auto'';
    ##color##    font = {
    ##color##      package = pkgs.nerd-fonts.atkynson-mono;
    ##color##      name = "AtkynsonMono Nerd Font";
    ##color##      size = 25;
    ##color##    };
    #themeFile = "gruvbox-dark-hard";
  };
}
