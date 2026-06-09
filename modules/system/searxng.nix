{...}:
{ services.searx = {
  enable = true;
  redisCreateLocally = true;
  settings.server = {
    bind_address = "::1";
    port = 8080;
    # WARNING: setting secret_key here might expose it to the nix cache
    # see below for the sops or environment file instructions to prevent this
    # secret_key = "Your secret key.";
  };
}; }
