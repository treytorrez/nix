{ pkgs, ...}:{
custom.focusMode = {
  enable = true;

  blockedApps = [
    { package = pkgs.steam;    binary = "steam"; }
    { package = pkgs.spotify;  binary = "spotify"; }
    { package = pkgs.neovide;  binary = "neovide"; }
  ];

  blockedDomains = [
    "youtube.com"    "www.youtube.com"
    "reddit.com"     "www.reddit.com"
    "twitter.com"    "x.com"
    "facebook.com"   "www.facebook.com"
    "instagram.com"  "www.instagram.com"
    "twitch.tv"      "www.twitch.tv"
    "search.nixos.org/" "www.search.nixos.org/"
    "nixos.org"    "wiki.nixos.org" 
    "www.nixos.org"    "www.wiki.nixos.org" 
  ];
};
}
