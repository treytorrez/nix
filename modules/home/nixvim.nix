{ pkgs, ...}:
{
  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    plugins = {
      lualine.enable = true;
      auto-save.enable = true;
      which-key.enable = true;
      neogit.enable = true;
      telescope.enable = true;
      fzf-lua.enable = true;
      markview.enable = true;
      mini-icons = {
	enable = true;
        mockDevIcons = true;
      };
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
      };

    };
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
            root_markers = [
              ".git"
            ];
          };
        };
	gopls = {
          enable = true;
	  packageFallback = true;
	  config = {
	    cmd = [ 
	      "gopls"
	    ];
	    filetypes = [
	      "go"
	      "gomod"
	    ];
	    root_markers = [
	      "go.mod"
	    ];
	  };
	};
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
	      ".git"
            ];
          };
        };
        
        nixd = {
          enable = true;
          packageFallback = true;
          config = {
            cmd = [ "nixd" ];
            filetypes = [ "nix" ];
            root_markers = [
              "flake.nix"
              "flake.lock"
              "default.nix"
              "shell.nix"
	      ".git"
            ];
          };
        };
        lua_ls = {
          enable = true;
        };
      };
    };
  };
}
