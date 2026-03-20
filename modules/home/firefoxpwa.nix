{ pkgs, ... }:
{
  programs.firefoxpwa = {
    enable = true;
    profiles."01KK88FE5JH5NP3304A20A3G8A" = {
      name = "Default";
      sites = {
        "01KK88FT89HT2N4X806DD1ZN3M" = {
          name = "Claude";
          url = "https://claude.ai/";
          manifestUrl = "https://claude.ai/manifest.json?v=3d5be240a3";
          desktopEntry.icon = pkgs.fetchurl {
            url = "https://claude.ai/favicon.svg";
            sha256 = "sVCIi8clevg+O4XTwr5ClPiJhgJvgWj2wS/B/eZpc1A=";
          };
        };
        "01KK8E1YMGJPZ2BVR9K2841JYE" = {
          name = "MDN Web Docs";
          url = "https://developer.mozilla.org/";
          manifestUrl = "https://developer.mozilla.org/manifest.f42880861b394dd4dc9b.json";
          desktopEntry.icon = pkgs.fetchurl {
            url = "https://developer.mozilla.org/favicon-192x192.png";
            sha256 = "0p8zgf2ba48l2pq1gjcffwzmd9kfmj9qc0v7zpwf2qd54fndifxr";
          };
        };
      };
    };
  };
}
