{
  config,
  ...
}:
let
  settingsFile = config.sops.templates."searxng-settings".path;
in
{
  services.searx = {
    enable = true;
    redisCreateLocally = true;
    settingsFile = settingsFile;
  };

  sops.templates."searxng-settings" = {
    content = ''
      use_default_settings: true
      server:
        bind_address: "::1"
        port: 8080
        secret_key: "${config.sops.placeholder."searxng-secret"}"
    '';
    owner = "searx";
    group = "searx";
  };
}
