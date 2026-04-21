{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = positron-bin;
    mutableExtensionsDir = false;
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
        ms-toolsai.jupyter-cell-tags
        ms-toolsai.jupyter-slideshow

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
	  version = "1.131.0";
	  sha256 = "s6ET/QEFIC3WJDbzJ49ki5EYZj/DRp81lPHUYZ9Jll4=";
	}
	# Shiny 
	{
	  name = "shiny";
	  publisher = "posit";
	  version = "1.4.0";
	  sha256 = "s6ET/QEFIC3WJDbzJ49ki5EYZj/DRp81lPHUYZ9Jll4=";
	}
	# Air R lang server
	{
	  name = "air-vscode";
	  publisher = "posit";
	  version = "0.24.0";
	  sha256 = "s6ET/QEFIC3WJDbzJ49ki5EYZj/DRp81lPHUYZ9Jll4=";
	}
	# Ruff
	{
	  name = "ruff";
	  publisher = "charliermarsh";
	  version = "2026.38.0";
	  sha256 = "s6ET/QEFIC3WJDbzJ49ki5EYZj/DRp81lPHUYZ9Jll4=";
	}
	# pyright
      ];
  };
}
