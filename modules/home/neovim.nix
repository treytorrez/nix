{inputs, pkgs, ...}:
{
  #---NEOVIM-----------------------------------------------------
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      image-nvim
      molten-nvim
      jupytext-nvim
    ];

    extraPackages = with pkgs; [
       imagemagick
       python3Packages.jupytext  # <-- add this
     ];

    extraLuaPackages = ps: with ps; [
      magick
    ];

    extraPython3Packages = ps: with ps; [
      pynvim
      jupyter-client
      cairosvg
      pnglatex
      plotly
      pyperclip
    ];

    extraLuaConfig = ''
      vim.opt.exrc = true
      vim.opt.secure = true

      vim.cmd.colorscheme("retrobox")

      -- Ctrl+Backspace deletes previous word in insert mode
      vim.keymap.set("i", "<C-BS>", "<C-w>", { silent = true })

      -- image.nvim (required before molten)
      require("image").setup({
        backend = "kitty",
        integrations = {},
        max_width = 100,
        max_height = 12,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      })

      -- molten-nvim
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_virt_lines = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_output_win_max_height = 20

      -- jupytext: auto-convert .ipynb to markdown for editing
      require("jupytext").setup({
        style = "markdown",
        output_extension = "md",
        force_ft = "markdown",
      })

      -- molten keymaps
      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",        { desc = "Molten init kernel", silent = true })
      vim.keymap.set("n", "<localleader>e",  ":MoltenEvaluateOperator<CR>", { desc = "Molten evaluate operator", silent = true })
      vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { desc = "Molten evaluate line", silent = true })
      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "Molten re-evaluate cell", silent = true })
      vim.keymap.set("v", "<localleader>r",  ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Molten evaluate visual", silent = true })
      vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>", { desc = "Molten enter output", silent = true })
      vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>",   { desc = "Molten hide output", silent = true })
      vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>",       { desc = "Molten delete cell", silent = true })
    '';
  };
}
