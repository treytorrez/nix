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


  {
    st = {
      name = "Simple Terminal";
      genericName = "Terminal";
      Comment = "Suckless terminal emulator for X";
      exec ="st -t \"Simple Terminal"\" -f \"AtkynsonMono Nerd Font:style=Semibold:size=12\"";
      terminal = false;
      type = "Application";
      Icon = "utilities-terminal";
      categories = [ "System" "TerminalEmulator" ];
      Keywords = [ "shell" "prompt" "command" "commandline" "cmd" ];
    };
  };


}
