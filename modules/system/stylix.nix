{
  pkgs,
  config,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;

  # ASCII wallpaper, generated from the Stylix palette so it follows theme
  # changes automatically. Text is right-aligned with figlet, then rendered
  # in the Stylix monospace font in the bottom-right corner.
  wallpaper = pkgs.runCommand "wallpaper.png" {
    nativeBuildInputs = [
      pkgs.figlet
      pkgs.imagemagick
      pkgs.fontconfig
    ];
    FONTCONFIG_FILE = pkgs.makeFontsConf {
      fontDirectories = [ config.stylix.fonts.monospace.package ];
    };
    XDG_CACHE_HOME = "$TMPDIR";
  } ''
    figlet -f standard -w 160 -r "I've broken this computer in ways you can't imagine" > ascii.txt

    font_file=$(fc-match -f '%{file}' '${config.stylix.fonts.monospace.name}')

    magick -background none -fill '${colors.base05}' \
      -font "$font_file" -pointsize 80 \
      label:@ascii.txt -trim +repage art.png

    # 2560x1600 panel. The art is capped at 30% of the screen height
    # (480px) and 2260px wide to leave margins on both sides.
    magick art.png -filter Lanczos -resize '2260x480>' art-fit.png

    magick -size 2560x1600 xc:'${colors.base00}' art-fit.png \
      -gravity southeast -geometry +150+140 -composite \
      -depth 8 "$out"
  '';
in
{
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    #config.stylix.targets.librewolf.profileNames` is not set. Declare profile
    #names with 'config.stylix.targets.librewolf.profileNames = [
    #"<PROFILE_NAME>" ];'.

    cursor = {
      package = pkgs.openzone-cursors;
      name = "OpenZone_White";
      size = 32;
    };

    # Base24 scheme; base16.nix maps base10-base17 onto base00-base0F when a
    # target only understands base16.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    image = wallpaper;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.atkynson-mono;
        name = "AtkynsonMono NFM";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;

      emoji = {
        package = pkgs.noto-fonts-monochrome-emoji;
        name = "Noto Monochrome Emoji";
      };
    };
  };

  # Stable path for anything that wants the generated wallpaper directly.
  environment.etc."wallpaper.png".source = wallpaper;

}
