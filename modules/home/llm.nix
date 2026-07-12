{ config, pkgs, lib, ... }:
{
  home.file.".config/io.datasette.llm/default_model.txt".text = "openrouter/deepseek/deepseek-v4-flash";

  home.activation.create-llm-keys = lib.hm.dag.entryAfter ["writeBoundary"] ''
    KEY_FILE="/run/secrets/openrouter-key"
    TARGET="$HOME/.config/io.datasette.llm/keys.json"
    if [ -f "$KEY_FILE" ]; then
      KEY=$(cat "$KEY_FILE")
      mkdir -p "$(dirname "$TARGET")"
      printf '{\n  "// Note": "This file stores secret API credentials. Do not share!",\n  "openrouter": "%s"\n}\n' "$KEY" > "$TARGET"
    fi
  '';
}