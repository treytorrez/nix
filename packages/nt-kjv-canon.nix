{
  stdenv,
  fetchFromGitHub,
  lib,
  ...
}:

stdenv.mkDerivation {
  pname = "nt-kjv-canon";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "pgattic";
    repo = "nt-kjv-canon";
    rev = "master";
    hash = "sha256-QBFaOG1eI02lQxcvOZfUVr2tgDs/jE4kQEfDBYioaw8=";
  };

  installPhase = ''
    cp -r . $out
  '';
}
