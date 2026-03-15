{ stdenv, fetchFromGitHub, lib, ... }:

stdenv.mkDerivation {
  pname = "bom-canon";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "pgattic";
    repo = "bom-canon";
    rev = "master";
    hash = "sha256-322PGkGIWs4M3SeULViZhQ4dEwvRnPZX2D6zGr+bCGU=";
  };

  installPhase = ''
    cp -r . $out
  '';
}
