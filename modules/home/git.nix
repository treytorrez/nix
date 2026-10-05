### [core]
###     pager = delta
###
### [interactive]
###     diffFilter = delta --color-only
###
### [delta]
###     navigate = true  # use n and N to move between diff sections
###     dark = true      # or light = true, or omit for auto-detection
###
### [merge]
###     conflictStyle = zdiff3

{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      core = {
        pager = "delta";
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      delta = {
        navigate = "true";
      };

      merge = {
        conflictStyle = "zdiff3";
      };
    };
  };
}
