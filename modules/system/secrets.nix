{
  config,
  ...
}:
{
  # WiFi configuration is split across per-host secret files:
  #   secrets/wifi-home.yaml    → ssid, psk
  #   secrets/wifi-school.yaml  → ssid, psk
  #   secrets/wifi-work.yaml    → ssid, psk
  # Hosts declare wifi profiles in their own default.nix using
  # sops.templates to fill in the ssid/psk placeholders.
}
