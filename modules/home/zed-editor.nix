{ ... }:
{
programs.zed-editor = {
  enable = true;
  extensions = [ "nix" "toml" "rust" "python" "markdown"];
  userSettings = 
  {
    buffer_line_height= "comfortable";
    relative_line_numbers= "enabled";
    autoscroll_on_clicks= false;
    vertical_scroll_margin= 5.0;
    which_key= {
      delay_ms= 200;
      enabled= true;
    };
    autosave= {
      after_delay= {
        milliseconds= 1000;
      };
    };
    hour_format= "hour12";
    theme= "Base16 Black Metal (Bathory)";
    vim_mode= true;
  }
;
};
}
