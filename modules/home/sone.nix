{config, pkgs,...}:
{

  let 
    c = config.lib.stylix.colors;

    soneStylix = pkgs.sone.overrideAttrs (old: {
  })
  in 
    {
  home.packages = [soneStylix];
}
}

