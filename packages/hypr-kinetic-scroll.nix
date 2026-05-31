{
  lib,
  fetchFromGitHub,
  hyprlandPlugins,
  pkg-config,
  pixman,
  libdrm,
  pango,
  libinput,
  systemd,
  wayland,
  libxkbcommon,
}:
hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hypr-kinetic-scroll";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "savonovv";
    repo = "hypr-kinetic-scroll";
    rev = "v0.3.0"; # e.g. "v0.3.0" or the full commit sha
    hash = lib.fakeHash; # use lib.fakeHash then replace
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    pixman
    libdrm
    pango
    libinput
    systemd  # provides libudev
    wayland
    libxkbcommon
  ];

  buildPhase = ''
    make CXX=$CXX CXXFLAGS="$CXXFLAGS"
  '';

  installPhase = ''
    install -Dm755 hypr-kinetic-scroll.so $out/lib/hyprland/hypr-kinetic-scroll.so
  '';

  meta = {
    homepage = "https://github.com/savonovv/hypr-kinetic-scroll";
    description = "Compositor-level kinetic touchpad scrolling for Hyprland";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [];
  };
}
