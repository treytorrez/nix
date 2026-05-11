{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    # TODO The flake can handle the hashes, check claude convo https://claude.ai/share/c3b0fc0b-f2ed-46be-8c6a-50aafc97e343
    profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        ms-python.black-formatter
        ms-toolsai.jupyter
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
      ];
  };
}
