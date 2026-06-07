<<<<<<< HEAD
{ ... }:
{
  services.searx = {
    enable = true;
    redisCreateLocally = true;
    settings.server = {
      bind_address = "::1";
      port = 8080;
      # WARNING: setting secret_key here might expose it to the nix cache
      # see below for the sops or environment file instructions to prevent this
      # secret_key = "Your secret key.";
    };
=======
{...}:
{ 
services.searx = {
  enable = true;
  redisCreateLocally = true;
  settings.server = {
    bind_address = "::1";
    port = 8080;
    # WARNING: setting secret_key here might expose it to the nix cache
    # see below for the sops or environment file instructions to prevent this
    secret_key = "1234567890";
>>>>>>> 4953773 (Successful build on server - 2026-06-07 03:46:07)
  };
}
