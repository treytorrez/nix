{inputs, ...}:
{
  #---NEOVIM-----------------------------------------------------
  programs.neovim = {
    enable = true;

    extraLuaConfig = ''
      vim.opt.exrc = true
      vim.opt.secure = true

      vim.cmd.colorscheme("retrobox")

      -- Ctrl+Backspace deletes previous word in insert mode
      vim.keymap.set("i", "<C-BS>", "<C-w>", { silent = true })
    '';
  };
}
