{ config, ... }:
{
  pi-coding-agent = {
    enable = true;
    configDir = "${config.home.homeDirectory}.config/pi/agent";
    context = ''
      This machine is a Nix OS device configured by a flake in `/etc/nixos`. It is one of a few devices defined in the flake but the quickest way to know what kind of device is the hostname. Prefer idiomatic and one-liner solutions. Apply YAGNI principles.
      '';
  defaultModel = "z-ai/glm-5.3";
  defaultThinkingLevel = "medium";
  packages = [
    "npm:pi-btw"
  ];
  retry = {
    enabled = true;
    maxRetries = 3;
  };
};
}
