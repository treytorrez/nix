{
  config,
  ...
}:
{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../../secrets/common.yaml;

    secrets = {
      # Set as treyt's login/sudo password at activation. Decrypted before
      # users exist (neededForUsers). users.mutableUsers stays true so the
      # root console can still reset a password if sops ever fails.
      "user-password-hash".neededForUsers = true;

      # Reusable Tailscale auth key (90-day max — rotate it).
      "tailscale-key" = { };

      # OpenRouter API key, read by treyt's home activation (llm.nix).
      "openrouter-key".owner = "treyt";

      # Env file for NetworkManager ensureProfiles: <NAME>_SSID / <NAME>_PSK.
      "wifi-env" = { };
    };
  };
}
