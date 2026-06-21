{ config, pkgs, ... }:
let
  c = config.lib.stylix.colors.withHashtag;

  # Pin to the version you have installed
  #  tidalSrc = pkgs.fetchFromGitHub {
  #    owner = "Mastermindzh";
  #    repo = "tidal-hifi";
  #    rev = "5.19.0";
  #    hash = "sha256-..."; # fill with nix-prefetch-url or nix flake prefetch
  #  };

  themeScss = pkgs.writeText "stylix-tidal.scss" ''
    @use "base" with (
      $bg-main:        ${c.base00},
      $bg-secondary:   ${c.base01},
      $bg-surface:     ${c.base02},
      $bg-elevated:    ${c.base03},
      $bg-hover:       ${c.base03},
      $bg-selection:   ${c.base02},

      $text-primary:   ${c.base05},
      $text-secondary: ${c.base06},
      $text-muted:     ${c.base04},
      $text-faint:     ${c.base03},

      $accent-primary: ${c.base0E},
      $accent-green:   ${c.base0B},
      $accent-red:     ${c.base08},
      $accent-blue:    ${c.base0D},
      $accent-purple:  ${c.base0E},
      $accent-cyan:    ${c.base0C},
      $accent-yellow:  ${c.base0A},

      $border-subtle:  ${c.base02},
      $border-dim:     ${c.base03}
    );
    @use "base-new" with ( /* same vars */ );
  '';

  compiledCss =
    pkgs.runCommand "tidal-stylix.css"
      {
        nativeBuildInputs = [ pkgs.sass ];
      }
      ''
        cp -r ${pkgs.tidal-hifi.src}/src/themes ./themes
        chmod -R +w ./themes
        cp ${themeScss} ./themes/stylix.scss
        sass --sourcemap=none ./themes/stylix.scss $out
      '';
in
{
  home.file.".config/tidal-hifi/themes/stylix.css".source = compiledCss;
  # Then select this file in tidal-hifi Settings → Theming
}
