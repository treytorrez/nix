{ config, pkgs, ... }:
let
  c = config.lib.stylix.colors;

  patchedMew = pkgs.mew.overrideAttrs (old: {
    preBuild = (old.preBuild or "") + ''
      cat > config.def.h <<EOF
      static int top              = 1;
      static const char *fonts[]  = { "${config.stylix.fonts.monospace.name}:size=14" };
      static const char *prompt   = NULL;
      static uint32_t colors[][2] = {
          /*               fg              bg           */
          [SchemeNorm] = { 0x${c.base05}ff, 0x${c.base00}ff },
          [SchemeSel]  = { 0x${c.base09}ff, 0x${c.base00}ff },
          [SchemeOut]  = { 0x000000ff,      0x00ffffff      },
      };
      static const char *output_name = NULL;
      static unsigned int lines      = 0;
      static const char worddelimiters[] = " ";
      EOF
    '';
  });
in
{
  home.packages = [ patchedMew ];
}
