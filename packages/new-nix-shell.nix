# packages/new-nix-shell.nix
{ pkgs }:

pkgs.writeShellApplication {
  name = "new-nix-shell";
  runtimeInputs = [ pkgs.fzf ];
  text = ''
    ENTRIES=(
      "Bun:bun"              "C / C++:c-cpp"        "Clojure:clojure"
      "Cue:cue"              "Deno:deno"             "Dhall:dhall"
      "Elixir:elixir"        "Elm:elm"               "Empty:empty"
      "Gleam:gleam"          "Go:go"                 "Hashicorp tools:hashi"
      "Haskell:haskell"      "Haxe:haxe"             "Java:java"
      "Jupyter:jupyter"      "Kotlin:kotlin"         "LaTeX:latex"
      "Nickel:nickel"        "Nim:nim"               "Nix:nix"
      "Node.js / node:node"  "OCaml:ocaml"           "Odin:odin"
      "Open Policy Agent / opa:opa"                  "PHP:php"
      "PlatformIO:platformio" "Protobuf:protobuf"    "Pulumi:pulumi"
      "Purescript:purescript" "Python:python"        "R:r"
      "Ruby:ruby"            "Rust:rust"             "Scala:scala"
      "Shell:shell"          "SWI-prolog:swi-prolog" "Swift:swift"
      "Typst:typst"          "Vlang:vlang"           "Zig:zig"
    )

    FZF_OPTS=(
  --height 20%
  --layout reverse
  --border
  --border-label "New shell.nix"
  --prompt "Which language?: "
)

    list() { for e in "''${ENTRIES[@]}"; do echo "''${e%%:*}"; done }

    lookup() {
      local name="$1"
      for e in "''${ENTRIES[@]}"; do
        [[ "''${e%%:*}" == "$name" ]] && { echo "''${e##*:}"; return; }
      done
      echo "unknown language: $name" >&2; exit 1
    }

    init() {
      local key
      key=$(lookup "$1")
      nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#''${key}"
    }

    case $# in
      0) if [[ -t 0 ]]; then
           sel=$(list | fzf "''${FZF_OPTS[@]}") && init "$sel"
         else
           IFS= read -r sel && init "$sel"
         fi ;;
      1) init "$1" ;;
      *) echo "usage: ''${0##*/} [language]" >&2; exit 1 ;;
    esac
  '';
}
