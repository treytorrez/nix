{
  pkgs,
  nixcord,
  config,
  lib,
  ...
}: # nixcord set to `nixcord.inputs` in flake.nix
{
  home.packages = [ ];
  imports = [ nixcord.homeModules.nixcord ];
  #---FIREFOX/LIBREWOLF----------------------------------------
  programs.firefoxpwa = {
    enable = true;
    profiles."01KK88FE5JH5NP3304A20A3G8A" = {
      name = "Default";
      sites."01KK88FT89HT2N4X806DD1ZN3M" = {
        name = "Claude";
        url = "https://claude.ai/";
        manifestUrl = "https://claude.ai/manifest.json?v=3d5be240a3";
        desktopEntry.icon = pkgs.fetchurl {
          url = "https://claude.ai/favicon.svg";
          sha256 = "sVCIi8clevg+O4XTwr5ClPiJhgJvgWj2wS/B/eZpc1A=";
        };
      };
    };

    profiles."01KK88FE5JH5NP3304A20A3G8A".sites."01KK8E1YMGJPZ2BVR9K2841JYE" = {
      name = "MDN Web Docs";
      url = "https://developer.mozilla.org/";
      manifestUrl = "https://developer.mozilla.org/manifest.f42880861b394dd4dc9b.json";
      desktopEntry.icon = pkgs.fetchurl {
        url = "https://developer.mozilla.org/favicon-192x192.png";
        sha256 = "0p8zgf2ba48l2pq1gjcffwzmd9kfmj9qc0v7zpwf2qd54fndifxr";
      };
    };
  };
  #---NVIM-----------------------------------------------------
  #---NIXCORD--------------------------------------------------
  programs.nixcord = {
    enable = true;

    # Choose your client (enable only one of these two)
    discord.vencord.enable = false; # Standard Vencord
    discord.equicord.enable = true; # Equicord (has more plugins)

    # Or these
    # equibop.enable = true;
    # dorion.enable = true;

    # Theming
    quickCss = "/* css goes here */";
    config = {
      useQuickCss = true;
      themeLinks = [
        #"https://raw.githubusercontent.com/link/to/some/theme.css"
      ];
      frameless = true;

      plugins = {
        messageLatency.enable = true;
        CustomRPC = {
          enable = true;
          config = {

          };
        };

      };
    };
  };
  #---ZSH-----------------------------------------------------
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # environment.pathsToLink = [ "/share/zsh" ];

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    plugins = [
      {
        name = "wd";
        src = pkgs.zsh-wd;
        file = "share/wd/wd.plugin.zsh";
        completions = [ "share/zsh/site-functions" ];
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
    shellAliases = {
      ll = "ls --color=tty -l";
      # IMPORTANT: use the flake rebuild so you don't accidentally go back to channels
      update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";

      # Optional fix: pass args through nix run correctly
      nixvim = "sudo nix run ~/nixvim-flake -- \"$@\"";

    };
    sessionVariables = {
      MANPAGER = "bat -l man --strip-ansi always --style='-numbers'";
      EDITOR = "nvim -u NONE";

    };
    profileExtra = ''
      eval "$(starship init zsh)"
    '';
  };

  # ---KITTY--------------------------------------------------
  programs.kitty.settings = {
    shell_integration = "enabled";
  };
  #---VS CODE--------------------------------------------------
  programs.vscode = {
    enable = true;
    # default mutableExtensionsDir
    # (removeAttrs config.programs.vscode.profiles [ "default" ]) == { }
    # this assigns extention immutability to any profile that isn't the default
    # profile
    mutableExtensionsDir = false;
    profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        ms-python.black-formatter
        ms-toolsai.jupyter
        asvetliakov.vscode-neovim
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "colab";
          publisher = "google";
          version = "0.3.0";
          sha256 = "O95bJuMQtQDj30nhw9yE1Spf/ViuakpcO2q9nf2iVtg=";
        }
      ];
  };

  #---STARSHIP--------------------------------------------------
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = lib.concatStrings [
        "[╭╴](fg:arrow)$username$os$git_branch(at $directory)$cmd_duration(via $python$conda$nodejs$c$rust$java)$fill $shell"
        "\n[╰─](fg:arrow)$character"
      ];

      add_newline = true;
      palette = "normal";

      palettes.normal = {
        arrow = "#333533";
        os = "#16f4d0";
        os_admin = "#e4ff1a";
        directory = "#9ffff5";
        time = "#bdfffd";
        node = "#a5e6ba";
        git = "#f17f29";
        git_status = "#DFEBED";
        python = "#edf67d";
        conda = "#70e000";
        java = "#F86279";
        rust = "#ffdac6";
        clang = "#caf0f8";
        duration = "#ce4257";
        text_color = "#EDF2F4";
        text_light = "#26272A";
      };

      username = {
        style_user = "bold os";
        style_root = "bold os_admin";
        format = "[ $user](fg:$style) ";
        disabled = false;
        show_always = true;
      };

      os = {
        format = "on [($name)]($style) ";
        style = "bold blue";
        disabled = true;

        symbols = {
          Alpine = " ";
          Arch = " ";
          Debian = " ";
          EndeavourOS = " ";
          Fedora = " ";
          Linux = " ";
          Macos = " ";
          Manjaro = " ";
          Mint = " ";
          NixOS = " ";
          openSUSE = " ";
          Pop = " ";
          SUSE = " ";
          Ubuntu = " ";
          Windows = " ";
        };
      };

      shell = {
        disabled = false;
        format = "using [$indicator](fg:cyan)";
        bash_indicator = "bash";
      };

      fill = {
        symbol = "─";
        style = "#333533";
      };

      character = {
        success_symbol = "[󰍟](fg:arrow)";
        error_symbol = "[󰍟](fg:red)";
      };

      directory = {
        format = "[$path](bold $style)[$read_only]($read_only_style) ";
        truncation_length = 2;
        style = "fg:directory";
        read_only_style = "fg:directory";
        before_repo_root_style = "fg:directory";
        truncation_symbol = "…/";
        truncate_to_repo = true;
        read_only = "  ";
      };

      time = {
        disabled = true;
        format = "at [󱑈 $time]($style)";
        time_format = "%H:%M";
        style = "bold fg:time";
      };

      cmd_duration = {
        format = "took [ $duration]($style) ";
        style = "bold fg:duration";
        min_time = 500;
      };

      git_branch = {
        format = "via [$symbol$branch]($style) ";
        style = "bold fg:git";
        symbol = " ";
      };

      git_status = {
        format = "[ $all_status$ahead_behind ]($style)";
        style = "fg:text_color bg:git";
        disabled = true;
      };

      docker_context = {
        disabled = false;
        symbol = " ";
      };

      package = {
        disabled = false;
      };

      nodejs = {
        format = "[ $symbol$version ]($style)";
        style = "bg:node fg:text_light";
        symbol = " ";
        version_format = "\${raw}";
        disabled = false;
      };

      python = {
        disabled = false;
        format = "[ \${symbol}\${pyenv_prefix}(\${version})( \\($virtualenv\\)) ]($style)";
        symbol = " ";
        version_format = "\${raw}";
        style = "bg:python fg:text_light";
      };

      conda = {
        format = "[ $symbol$environment ]($style)";
        style = "bg:conda fg:text_light";
        ignore_base = false;
        disabled = false;
        symbol = " ";
      };

      java = {
        format = "[ $symbol$version ]($style)";
        style = "bg:java fg:text_light";
        version_format = "\${raw}";
        symbol = " ";
        disabled = true;
      };

      c = {
        format = "[ $symbol($version(-$name)) ]($style)";
        style = "bg:clang fg:text_light";
        symbol = " ";
        version_format = "\${raw}";
        disabled = false;
      };

      rust = {
        format = "[ $symbol$version ]($style)";
        style = "bg:rust fg:text_light";
        symbol = " ";
        version_format = "\${raw}";
        disabled = false;
      };
    };
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "25.11";
}
