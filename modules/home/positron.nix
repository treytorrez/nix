{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.positron-bin.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        ln -sf $out/share/positron/resources/app/product.json $out/product.json
      '';
    });
    mutableExtensionsDir = false;
    dataFolderName = ".positron";
    profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        ms-python.python
        ms-python.vscode-pylance

        # Python Debugger
        ms-python.debugpy
        ms-python.black-formatter

        # Pyright
        ms-pyright.pyright

        # Jupyter
        # Jupyter Keymap
        # Jupyter cell tags
        # Jupyter slide show
        ms-toolsai.jupyter
        ms-toolsai.jupyter-keymap
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow

        asvetliakov.vscode-neovim # TODO: enable start clean option or create a neovim package specifically for vs code

      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "chatgpt";
          publisher = "openai";
          version = "26.5406.31014";
          sha256 = "s6ET/QEFIC3WJDbzJ49ki5EYZj/DRp81lPHUYZ9Jll4=";
        }
        {
          name = "datawrangler";
          publisher = "ms-toolsai";
          version = "1.24.0";
          sha256 = "FWzrxf5uaPcbu1JCiYxsbkju1mY3n3F2vGLvfMuZxlc=";
        }
        {
          name = "colab";
          publisher = "google";
          version = "0.3.0";
          sha256 = "O95bJuMQtQDj30nhw9yE1Spf/ViuakpcO2q9nf2iVtg=";
        }
        # Quarto
        {
          name = "quarto";
          publisher = "quarto";
          version = "1.127.0";
          sha256 = "sha256-RHvMXBPOEGubujCi6Z04J2BjtPTwTVOU9VjYtmgRb/M=";
        }
        # Shiny
        {
          name = "shiny";
          publisher = "posit";
          version = "1.3.4";
          sha256 = "sha256-FGfpomMBRwf3p2b4+qfFdluzaf0GVW7zXEYEn4JCI7M=";
        }
        # Air R lang server
        {
          name = "air-vscode";
          publisher = "posit";
          version = "0.24.0";
          sha256 = "sha256-f12hfBxbYlB+8gCH7hE8JsDa/kCAp/5h3p/4cXFYZFc=";
        }
        # Ruff
        {
          name = "ruff";
          publisher = "charliermarsh";
          version = "2026.38.0";
          sha256 = "sha256-NU/XkSeNt0A1dX9E2ej/RebapnhOQ+O8Yi5X5BngV14=";
        }
      ];
  };
}
