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
      auto-save-nvim
      which-key-nvim
    ];

    extraPackages = with pkgs; [
      imagemagick
      python3Packages.jupytext
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

      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true

      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.cmd.colorscheme("retrobox")

      -- Ctrl+Backspace deletes previous word in insert mode
      vim.keymap.set("i", "<C-BS>", "<C-w>", { silent = true })

      -- which-key
      require("which-key").setup({})

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

      -- auto-import outputs when kernel is ready
      vim.api.nvim_create_autocmd("User", {
        pattern = "MoltenInitPost",
        callback = function()
          vim.cmd("MoltenImportOutput")
        end,
      })

      -- auto-export outputs on save for .ipynb files
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.ipynb",
        callback = function()
          vim.cmd("MoltenExportOutput!")
        end,
      })

      -- jupytext
      require("jupytext").setup({
        style = "markdown",
        output_extension = "md",
        force_ft = "markdown",
      })

      -- auto-save
      require("auto-save").setup({
        enabled = true,
        execution_message = { message = "" },
        events = { "InsertLeave", "TextChanged" },
        debounce_delay = 1000,
      })

      -- molten keymaps
      vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>",             { desc = "Molten init kernel", silent = true })
      vim.keymap.set("n", "<leader>e",  ":MoltenEvaluateOperator<CR>", { desc = "Molten evaluate operator", silent = true })
      vim.keymap.set("n", "<leader>rl", ":MoltenEvaluateLine<CR>",     { desc = "Molten evaluate line", silent = true })
      vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>",   { desc = "Molten re-evaluate cell", silent = true })
      vim.keymap.set("v", "<leader>r",  ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Molten evaluate visual", silent = true })
      vim.keymap.set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>", { desc = "Molten enter output", silent = true })
      vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>",       { desc = "Molten hide output", silent = true })
      vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>",           { desc = "Molten delete cell", silent = true })
    '';
  };
}
