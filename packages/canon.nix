{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "canon";
  version = "unstable-2024";

  src = fetchFromGitHub {
    owner = "pgattic";
    repo = "canon";
    rev = "master";
    hash = lib.fakeHash; # replace with: nix-prefetch-url --unpack <tarball-url>
                         # or run once and let nix tell you the correct hash
  };

  vendorHash = null; # no third-party Go dependencies

  meta = {
    description = "Extensible book/scripture referencer";
    homepage = "https://github.com/pgattic/canon";
    license = lib.licenses.mit;
    mainProgram = "canon";
  };
}
