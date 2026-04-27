{ pkgs, ...}:
{
  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    plugins = {
      lualine.enable = true;
      auto-save.enable = true;
      gitgutter.enable = true;
      comfy-line-numbers.enable = true;

    };
  };
}
