{ pkgs, lib, hostname, ... }:
{
  # User systemd service (system-level unit file, runs as each logged-in user).
  # Deliberately NOT enabled at boot: a resident llama-server holds ~5GB
  # RAM/VRAM 24/7. Start on demand with:
  #   systemctl --user start llama-server
  # Or make it permanent: `systemctl --user enable --now llama-server`
  # Shared model store: /var/lib/models (HF_HOME etc. point there).
  # For llama-server, pass --model /var/lib/models/<file>.gguf or edit below.
  #
  # OpenAI-compatible API at http://localhost:8080/v1
  #
  # ollama models being replaced (GGUF needed, can't convert ollama blobs):
  #   qwen3.5:9b, qwen3.5:4b, tinyllama:latest (were in /var/lib/ollama, deleted)
  #   hf.co/empero-ai/Qwen3.8-9B-Distill-GGUF:Q4_K_M (recovered to ~/.local/share/llama.cpp/)
  systemd.user.services.llama-server = {
    description = "llama.cpp OpenAI-compatible server";
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.llama-cpp}/bin/llama-server \
          --host 127.0.0.1 --port 8080 \
          --model %h/.local/share/llama.cpp/Qwen3.8-9B-Distill-GGUF-Q4_K_M.gguf \
          --ctx-size 16384 --ngl 99
      '';
      Restart = "on-failure";
    };
    # Missing gfx1032 kernels in the nix build cause
    # "LLVM ERROR: CachedFileStream was not committed"; gfx1030 override fixes it.
    environment = lib.optionalAttrs (hostname == "laptop") {
      HSA_OVERRIDE_GFX_VERSION = "10.3.0";
    };
  };
}
