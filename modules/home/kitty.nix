{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    enableGitIntegration = true;
    extraConfig = ''
      font_family      family='AtkynsonMono Nerd Font' style=Light
      bold_font        auto
      italic_font      family='AtkynsonMono Nerd Font' style='Light Italic'
      bold_italic_font auto'';
    font = {
      package = pkgs.nerd-fonts.atkynson-mono;
      name = "AtkynsonMono Nerd Font";
      size = 25;
    };
    #themeFile = "gruvbox-dark-hard";
  };
}
