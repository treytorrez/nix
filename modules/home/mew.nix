{ config, pkgs, ... }: #TODO: adapt a dmenu patch to allow this to appear center screen? or perhaps use another dmenu clone... speed and widespread support are my priorities here. something like rofi (i assume) is large and slow comparatively.
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
          [SchemeSel]  = { 0x${c.base08}ff, 0x${c.base00}ff },
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
