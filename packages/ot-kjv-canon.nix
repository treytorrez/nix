{
  stdenv,
  fetchFromGitHub,
  lib,
  ...
}:

stdenv.mkDerivation {
  pname = "ot-kjv-canon";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "pgattic";
    repo = "ot-kjv-canon";
    rev = "master";
    hash = "sha256-U17YAQI8W0MEteB3jDBfDU4AdKGr9ayMPgqdDRpEghc=";
  };

  installPhase = ''
    cp -r . $out
  '';
}
