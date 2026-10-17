{
  config,
  ...
}:
{
  # hostname is set per-host in hosts/<name>/default.nix
  networking = {
    networkmanager.enable = true;
    hosts = {
      "127.0.0.1:1234" = [ "chat.local" ];
    };

    # WiFi profiles with PSKs pulled from the sops-decrypted env file
    # (secrets/wifi-env: HOME_SSID/HOME_PSK, SCHOOL_..., WORK_...).
    # SSIDs inside $VARS stay out of git; env interpolation happens at
    # profile generation.
    networkmanager.ensureProfiles = {
      environmentFiles = [ config.sops.secrets."wifi-env".path ];
      profiles = {
        home = {
          connection = { id = "home"; type = "wifi"; };
          wifi = { ssid = "$HOME_SSID"; mode = "infrastructure"; };
          wifi-security = { key-mgmt = "wpa-psk"; psk = "$HOME_PSK"; };
        };
        school = {
          connection = { id = "school"; type = "wifi"; };
          wifi = { ssid = "$SCHOOL_SSID"; mode = "infrastructure"; };
          wifi-security = { key-mgmt = "wpa-psk"; psk = "$SCHOOL_PSK"; };
        };
        work = {
          connection = { id = "work"; type = "wifi"; };
          wifi = { ssid = "$WORK_SSID"; mode = "infrastructure"; };
          wifi-security = { key-mgmt = "wpa-psk"; psk = "$WORK_PSK"; };
        };
      };
    };
  };
}
