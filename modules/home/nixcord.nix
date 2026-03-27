{ ... }:
{
  programs.nixcord = {
    enable = true;
    discord.vencord.enable = false;
    discord.equicord.enable = true;
    quickCss = "/* css goes here */";
    config = {
      useQuickCss = true;
      themeLinks = [ ];
      frameless = true;
      plugins = {
        messageLatency.enable = true;
      };
    };
  };
}

