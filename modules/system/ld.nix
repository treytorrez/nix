{ pkgs, ...}:
{
programs.nix-ld = {
  enable = true;
  libraries = with pkgs; [
    stdenv.cc.cc.lib    # libstdc++
    stdenv.cc.cc        # libstdc++ (some packages need this too)
    zlib
    libGL
    glib
    openssl
  ];
};
}
