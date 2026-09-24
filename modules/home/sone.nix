{config, pkgs,...}:
{

  let 
    c = config.lib.stylix.colors;

  in 
    {
  home.packages = [soneStylix];
  home.file.".config/sone/theme.json" = {
    target = ".config/sone/theme.json";
    text =  ''
{
  "version": 1,
  "preset": "custom",
  "custom": {
    "accent": "${c.base00}",
    "background": "${c.base0B}"
  }
}
      '';
  };

}
}

