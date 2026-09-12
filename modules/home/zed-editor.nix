{ ... }:
{
programs.zed-editor = {
  enable = true;
  extensions = [ "nix" "toml" "rust" "python" "markdown"];
  userSettings = {
    hour_format = "hour12";
    vim_mode = true;
  };
};
}
