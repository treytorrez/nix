{
  stdenv,
  fetchFromGitHub,
  lib,
  ...
}:

stdenv.mkDerivation {
  pname = "pogp-canon";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "pgattic";
    repo = "pogp-canon";
    rev = "master";
    hash = "sha256-QEBK3IiD5QvsegF1j0v8ClUYePzQyXE3bR4W4AWmhBg=";
  };

  installPhase = ''
    cp -r . $out
  '';
}
