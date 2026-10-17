{
  config,
  ...
}:
{
  services.tailscale = {
    enable = true;
    # Zero-touch enrollment: tailscaled-autoconnect only runs `tailscale up
    # --auth-key ...` when the node is in NeedsLogin/NeedsMachineAuth state,
    # so a *reusable* 90-day auth key works across reboots and re-auths.
    authKeyFile = config.sops.secrets."tailscale-key".path;
    openFirewall = true;
  };
}
