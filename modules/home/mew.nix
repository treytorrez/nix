{ config, pkgs, ... }:
let
  c = config.lib.stylix.colors;

  patchedMew = pkgs.mew.overrideAttrs (old: {
    # Wayland ports of dmenu's center, alpha, and border patches.
    patches = (old.patches or [ ]) ++ [
      ./mew-center.patch
      ./mew-alpha.patch
      ./mew-border.patch
    ];
    preBuild = (old.preBuild or "") + ''
      cat > config.def.h <<EOF
      static int top              = 1;
      static int centered         = 1;
      static int min_width        = 500;
      static unsigned int alpha   = 0xa6;
      static const char *fonts[]  = { "${config.stylix.fonts.monospace.name}:size=14" };
      static const char *prompt   = NULL;
      static uint32_t colors[][2] = {
          /*               fg              bg           */
          [SchemeNorm] = { 0x${c.base05}ff, 0x${c.base00}ff },
          [SchemeSel]  = { 0x${c.base08}ff, 0x${c.base00}ff },
          [SchemeOut]  = { 0x${c.base04}ff, 0x${c.base00}ff },
          [SchemeBorder] = { 0x${c.base03}ff, 0x${c.base03}ff },
      };
      static const char *output_name = NULL;
      static unsigned int lines      = 0;
      static unsigned int border_width = 2;
      static const char worddelimiters[] = " ";
      EOF
    '';
  });
in
{
  home.packages = [ patchedMew ];
}
