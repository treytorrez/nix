{ ... }:
{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "node.param.Props" = [
        { "volume" = 1.15; }
      ];
    };
  };
}
