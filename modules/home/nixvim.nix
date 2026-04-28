{ pkgs, ...}:
{
  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    plugins = {
      lualine.enable = true;
      auto-save.enable = true;
      gitgutter.enable = true;

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
