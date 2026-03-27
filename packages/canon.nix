{
  lib,
  buildGoModule,
  fetchFromGitHub,
  canonSrc,
}:

buildGoModule rec {
  pname = "canon";
  version = "unstable-2024";

  src = canonSrc;

  vendorHash = null; # no third-party Go dependencies

  meta = {
    description = "Extensible book/scripture referencer";
    homepage = "https://github.com/pgattic/canon";
    license = lib.licenses.mit;
    mainProgram = "canon";
  };
}
