{ pkgs, ...}:
{
programs.nix-ld = {
  enable = true;
  libraries = with pkgs; [
    stdenv.cc.cc.lib    # libstdc++
    zlib                # libz
    libGL               # for matplotlib, seaborn
    glib                # libglib
    openssl             # for various network libs
  ];
};
}
