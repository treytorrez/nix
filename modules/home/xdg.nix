#  [Desktop Entry]
#  Name=Simple Terminal
#  GenericName=Terminal
#  Comment=Suckless terminal emulator for X
#  Exec=st -t "Simple Terminal" -f "Source Code Pro:style=Semibold:size=12"
#  Terminal=false
#  Type=Application
#  Encoding=UTF-8
#  Icon=utilities-terminal
#  Categories=System;TerminalEmulator;
#  Keywords=shell;prompt;command;commandline;cmd;
{...}:
{

xdg.desktopEntries = {
    st = {
      name = "Simple Terminal";
      genericName = "Terminal";
      comment = "Suckless terminal emulator for X";
      exec ="st -t \"Simple Termina\" -f \"AtkynsonMono Nerd Font:style=Semibold:size=35\"";
      terminal = false;
      type = "Application";
      icon = "utilities-terminal";
      categories = [ "System" "TerminalEmulator" ];
      #keywords = [ "shell" "prompt" "command" "commandline" "cmd" ];
    };
  };


}
