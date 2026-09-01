{ ... }:
let
  tridactylrc = ''
    " General Settings
    set update.lastchecktime 1787615607462
    set update.lastnaggedversion 1.24.6
    set configversion 2.0
    set smoothscroll true

    " Binds
    bind K tabprev
    bind J tabnext

    " Autocmds
    autocmd DocStart undefined mode ignore
    autocmd DocStart zstream.mov/media mode ignore

    " For syntax highlighting see https://github.com/tridactyl/vim-tridactyl
    " vim: set filetype=tridactyl
  '';
in
{
  home.file.".tridactylrc" = {
    target = ".tridactylrc";
    text = tridactylrc;
  };
}
