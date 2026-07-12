{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  #fonts.font = ["nerd-fonts.atkynson-mono"];
  programs.nixvim = {
    enable = true;
    nixpkgs.source = inputs.nixpkgs;
    # some of the warnings say to do this
    nixpkgs.config.allowUnfree = true;

    opts = {
      splitright = true;
      splitbelow = true;
      expandtab = true; # Use spaces instead of tabs
      tabstop = 2; # Tab width is 2 spaces
      shiftwidth = 2; # Indent by 2 spaces
      softtabstop = 2; # Tab key inserts 2 spaces
      exrc = true;
      signcolumn = "no";
      number = true;
      relativenumber = true;
      fillchars = "vert:▏";
      cursorline = true;
      #guifont = "${lib.escape [" "] config.stylix.fonts.monospace.name}:${toString config.stylix.fonts.sizes.applications}";
    };

    globals = {
      netrw_preview = 1;
      netrw_liststyle = 3;
    };

    # Performance optimizations
    performance.byteCompileLua = {
      enable = true;
      configs = true;
      initLua = true;
      nvimRuntime = true;
      plugins = true;
    };

    #colorschemes.gruvbox.enable = true;

    extraConfigLua = ''
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
          if ok then
            local orig = cmp_nvim_lsp._on_insert_enter
            cmp_nvim_lsp._on_insert_enter = function()
              local ok2 = pcall(vim.lsp.get_clients)
              if not ok2 then
                return
              end
              orig()
            end
          end
        end,
      })
    '';

    globals.mapleader = " ";

    plugins = {
      # Lazy loading infrastructure
      lz-n.enable = true;

      # UI/UX
      # TODO: https://nix-community.github.io/nixvim/plugins/typst-preview/index.html
      # TODO: https://nix-community.github.io/nixvim/plugins/typst-vim/index.html
      # TODO: typst previewer & typst fomatter/linter/whatever
      lualine.enable = true;
      neoscroll.enable = true;
      auto-save.enable = true;
      tiny-inline-diagnostic.enable = true;
      colorizer = {
        enable = true;

      };
      mini-surround.enable = true;
      which-key = {
        enable = true;
        settings = {
          spec = [
            {
              __unkeyed = "<leader>f";
              group = "Find/File";
            }
            {
              __unkeyed = "<leader>g";
              group = "Git";
            }
            {
              __unkeyed = "<leader>l";
              group = "LSP";
            }
            {
              __unkeyed = "<leader>n";
              group = "Notebook";
            }
            {
              __unkeyed = "<leader>q";
              group = "Quarto";
            }
            {
              __unkeyed = "<leader>t";
              group = "Toggle";
            }
            {
              __unkeyed = "<leader>b";
              group = "Buffer";
            }
          ];
        };
      };
      lazygit.enable = true;
      telescope.enable = true;
      fzf-lua.enable = true;
      markview.enable = true;
      mini-icons = {
        enable = true;
        mockDevIcons = true;
      };
      mini-indentscope = {
          enable = true;
          opts = {
            symbol = "│"; # your custom symbol
            draw = {
              animation = pkgs.lib.mkLuaInline ''
                return require("mini.indentscope").gen_animation.none()
              '';
            };
          };
      };

      # Completion
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
        filetype = {
          quarto = {
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "otter"; }
            ];
          };
          markdown = {
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "otter"; }
            ];
          };
        };
      };

      # Syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        lazyLoad.settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
        };
      };

      # Notebook/Quarto support
      quarto = {
        enable = true;
        lazyLoad.settings = {
          ft = "quarto";
        };
      };

      # LSP in code blocks
      otter = {
        enable = true;
        autoActivate = false;
        lazyLoad.settings = {
          ft = [
            "quarto"
            "markdown"
          ];
        };
      };

      # Image rendering (Kitty support)
      image = {
        enable = true;
        lazyLoad.settings = {
          ft = [
            "quarto"
            "markdown"
            "vimwiki"
          ];
        };
      };

      # Jupyter kernel
      molten = {
        enable = true;
        python3Dependencies =
          p: with p; [
            pynvim
            jupyter-client
            cairosvg
            ipython
            nbformat
            ipykernel
            # Add R kernel support
          ];
        settings = {
          image_provider = "image.nvim";
          auto_open_output = true;
          enter_output_behavior = "open_and_enter";
          output_win_max_height = 20;
          wrap_output = true;
          virt_text_output = true;
        };
        #---
        # Molten doesn't lazy load commands apparently :(
        #---
        #        lazyLoad.settings = {
        #          cmd = [
        #            "MoltenInit"
        #            "MoltenEvaluateOperator"
        #            "MoltenEvaluateLine"
        #            "MoltenEvaluateVisual"
        #            "MoltenReevaluateCell"
        #            "MoltenDelete"
        #            "MoltenShowOutput"
        #            "MoltenHideOutput"
        #          ];
        #        };
      };
    };

    # LSP Configuration
    lsp = {
      servers = {
        "*" = {
          config = {
            capabilities = {
              textDocument = {
                semanticTokens = {
                  multilineTokenSupport = true;
                };
              };
            };
            root_markers = [ ".git" ];
          };
        };
        sqruff = {
          enable = true;
          config = {
            cmd = [
              "sqruff"
              "lint"
              "."
            ];
            filetypes = [
              "sql"
            ];
          };
        };

        harper_ls = {
          enable = true;
          # any reason to have this?
          #packageFallback = true;
          config = {
            cmd = [
              "harper-ls"
              "--stdio"
            ];
            filetypes = [
              "markdown"
              "text"
              "tex"
              "typst"
            ];
          };
        };
        # Go
        gopls = {
          enable = true;
          packageFallback = true;
          config = {
            cmd = [ "gopls" ];
            filetypes = [
              "go"
              "gomod"
            ];
            root_markers = [ "go.mod" ];
          };
        };

        # Python
        pylsp = {
          enable = true;
          packageFallback = true;
          config = {
            cmd = [ "pylsp" ];
            filetypes = [ "python" ];
            root_markers = [
              "pyproject.toml"
              "setup.py"
              "setup.cfg"
              "requirements.txt"
              "pyrightconfig.json"
            ];
          };
        };

        # Nix
        nil = {
          enable = true;
          packageFallback = true;
          config = {
            cmd = [ "nil" ];
            filetypes = [ "nix" ];
            root_markers = [
              "flake.nix"
              "flake.lock"
              "default.nix"
              "shell.nix"
            ];
          };
        };

        # R
        air = {
          enable = true;
          packageFallback = true;
          config = {
            cmd = [
              "air"
              "language-server"
            ];
            filetypes = [
              "r"
              "rmd"
              "quarto"
            ];
            root_markers = [
              ".git"
              "DESCRIPTION"
              "renv.lock"
            ];
          };
        };

        # Lua
        lua_ls = {
          enable = true;
        };
      };
    };

    # Keybindings - Spacemacs style
    keymaps = [
      # ===== Notebook Operations (n) =====
      {
        mode = "n";
        key = "<leader>ni";
        action = "<cmd>MoltenInit<cr>";
        options.desc = "Initialize kernel";
      }
      {
        mode = "n";
        key = "<leader>nr";
        action = "<cmd>MoltenEvaluateLine<cr>";
        options.desc = "Run current line";
      }
      {
        mode = "v";
        key = "<leader>nr";
        action = ":<C-u>MoltenEvaluateVisual<cr>gv";
        options.desc = "Run selection";
      }
      {
        mode = "n";
        key = "<leader>nR";
        action = "<cmd>MoltenReevaluateCell<cr>";
        options.desc = "Re-run cell";
      }
      {
        mode = "n";
        key = "<leader>no";
        action = "<cmd>MoltenShowOutput<cr>";
        options.desc = "Show output";
      }
      {
        mode = "n";
        key = "<leader>nh";
        action = "<cmd>MoltenHideOutput<cr>";
        options.desc = "Hide output";
      }
      {
        mode = "n";
        key = "<leader>nd";
        action = "<cmd>MoltenDelete<cr>";
        options.desc = "Delete cell";
      }
      {
        mode = "n";
        key = "<leader>nx";
        action = "<cmd>MoltenInterrupt<cr>";
        options.desc = "Interrupt execution";
      }

      # ===== Quarto Operations (q) =====
      {
        mode = "n";
        key = "<leader>qp";
        action = "<cmd>QuartoPreview<cr>";
        options.desc = "Preview document";
      }
      {
        mode = "n";
        key = "<leader>qc";
        action = "<cmd>QuartoClosePreview<cr>";
        options.desc = "Close preview";
      }
      {
        mode = "n";
        key = "<leader>qa";
        action = "<cmd>QuartoActivate<cr>";
        options.desc = "Activate Quarto";
      }

      # ===== LSP Operations (l) =====
      {
        mode = "n";
        key = "<leader>ld";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "<leader>lD";
        action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
        options.desc = "Go to declaration";
      }
      {
        mode = "n";
        key = "<leader>lr";
        action = "<cmd>lua vim.lsp.buf.references()<cr>";
        options.desc = "Find references";
      }
      {
        mode = "n";
        key = "<leader>li";
        action = "<cmd>lua vim.lsp.buf.implementation()<cr>";
        options.desc = "Go to implementation";
      }
      {
        mode = "n";
        key = "<leader>lh";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options.desc = "Hover documentation";
      }
      {
        mode = "n";
        key = "<leader>ls";
        action = "<cmd>lua vim.lsp.buf.signature_help()<cr>";
        options.desc = "Signature help";
      }
      {
        mode = "n";
        key = "<leader>la";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options.desc = "Code actions";
      }
      {
        mode = "n";
        key = "<leader>ldi";
        action = "<cmd>lua vim.diagnostic.open_float()<cr>";
        options.desc = "View Diagnostic";
      }
      {
        mode = "n";
        key = "<leader>lf";
        action = "<cmd>lua vim.lsp.buf.format()<cr>";
        options.desc = "Format buffer";
      }
      {
        mode = "n";
        key = "<leader>ln";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
        options.desc = "Rename symbol";
      }

      # ===== Disabled built-in keys =====
      {
        mode = "i";
        key = "<C-w>";
        action = "<Nop>";
        options.desc = "Disabled Ctrl-w in insert mode";
      }

      # ===== File/Find Operations (f) =====
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Grep files";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Find buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
        options.desc = "Help tags";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Telescope oldfiles<cr>";
        options.desc = "Recent files";
      }

      # ===== Git Operations (g) =====
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<cr>";
        options.desc = "LazyGit";
      }
      {
        mode = "n";
        key = "<leader>gsp";
        action = "<cmd>!git stash pop<cr>";
        options.desc = "Git stash pop";
      }
      #      {
      #        mode = "n";
      #        key = "<leader>gp";
      #        action = "<cmd>LazyGit push<cr>";
      #        options.desc = "Push";
      #      }
      {
        mode = "n";
        key = "<leader>gl";
        action = "<cmd>LazyGitLog<cr>";
        options.desc = "Log";
      }

      # ===== Buffer Operations (b) =====
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options.desc = "Delete buffer";
      }
      {
        mode = "n";
        key = "<leader>bn";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = "<cmd>bprevious<cr>";
        options.desc = "Previous buffer";
      }

      # Quick access keybinds (no prefix)
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options.desc = "LSP Hover";
      }
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<cr>";
        options.desc = "Find references";
      }
    ];
  };
  home.packages = with pkgs; [
    (rWrapper.override {
      packages = with rPackages; [
        IRkernel
        # Add other R packages you want
        ggplot2
        dplyr
        tidyr
      ];
    })
  ];
}
