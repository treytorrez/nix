{ pkgs, lib, hostname, ... }:
let
  # On laptop, both RX 6800S (gfx1032, dGPU) and Radeon 680M (gfx1035, iGPU) are
  # exposed to ROCm. Having both visible triggers an amd_comgr multi-target bundle
  # bug ("LLVM ERROR: CachedFileStream was not committed") and splits layers onto
  # slow iGPU system RAM. Pinning HIP_VISIBLE_DEVICES=0 isolates the RX 6800S dGPU.
  llama-cpp-wrapped = pkgs.symlinkJoin {
    name = "llama-cpp-wrapped-${pkgs.llama-cpp.version}";
    paths = [ pkgs.llama-cpp ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for f in $out/bin/*; do
        if [ -x "$f" ] && [[ "$f" != *.so* ]]; then
          wrapProgram "$f" \
            ${lib.optionalString (hostname == "laptop") "--set-default HIP_VISIBLE_DEVICES 0"} \
            --set-default LLAMA_ARG_MODELS_DIR /var/lib/models \
            --set-default HF_HOME /var/lib/models/hf \
            --set-default HF_HUB_CACHE /var/lib/models/hf/hub
        fi
      done
    '';
  };
in
{
  environment.systemPackages = [ llama-cpp-wrapped ];

  # Shared local model store for inference tools. Drop GGUF/HF files in
  # /var/lib/models (writable by the `models` group).
  users.groups.models = { };
  users.users.treyt.extraGroups = [ "models" ];
  systemd.tmpfiles.rules = [ "d /var/lib/models 0775 root models -" ];

  environment.sessionVariables = {
    HF_HOME = "/var/lib/models/hf";
    HF_HUB_CACHE = "/var/lib/models/hf/hub";
    MODELS_DIR = "/var/lib/models";
    LLAMA_ARG_MODELS_DIR = "/var/lib/models";
    LLAMA_BASE_URL = "http://127.0.0.1:8080";
  } // lib.optionalAttrs (hostname == "laptop") {
    HIP_VISIBLE_DEVICES = "0";
  };

  # Runs in router mode (~18MB RAM idle): discovers all models in /var/lib/models
  # and /var/lib/models/hf/hub, loads on demand, and unloads after 5m idle.
  # OpenAI-compatible API at http://127.0.0.1:8080/v1
  #
  # Previous ollama models (for reference):
  #   qwen3.5:9b, qwen3.5:4b, tinyllama:latest
  #   Qwen3.8-9B-Distill-GGUF-Q4_K_M (in /var/lib/models/)
  systemd.user.services.llama-server = {
    description = "llama.cpp OpenAI-compatible router server";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      # ctx-size here is the source of truth: pi regenerates its model limits
      # from what this server advertises (models-store.json is only a cache).
      # 32K ctx + q8_0 KV cache (~halves KV size) keeps the 9B model within
      # the RX 6800S's 8GB VRAM. Pi tools that need more must set per-model
      # ctx via model presets or a dedicated single-model server instance.
      ExecStart = "${llama-cpp-wrapped}/bin/llama-server --host 127.0.0.1 --port 8080 --models-dir /var/lib/models --sleep-idle-seconds 300 --ctx-size 32768 -ctk q8_0 -ctv q8_0 -ngl 99";
      Restart = "on-failure";
    };
  };
}
