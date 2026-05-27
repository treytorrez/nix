{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = lib.concatStrings [
        "[╭╴](fg:arrow)$username$os$git_branch(at $directory)$cmd_duration(via $python$conda$nodejs$c$rust$java)$fill $shell"
        "\n[╰─](fg:arrow)$character"
      ];

      add_newline = true;
      ##color##      palette = "normal";

      ##color##      palettes.normal = {
      ##color##        arrow = "#333533";
      ##color##        os = "#16f4d0";
      ##color##        os_admin = "#e4ff1a";
      ##color##        directory = "#9ffff5";
      ##color##        time = "#bdfffd";
      ##color##        node = "#a5e6ba";
      ##color##        git = "#f17f29";
      ##color##        git_status = "#DFEBED";
      ##color##        python = "#edf67d";
      ##color##        conda = "#70e000";
      ##color##        java = "#F86279";
      ##color##        rust = "#ffdac6";
      ##color##        clang = "#caf0f8";
      ##color##        duration = "#ce4257";
      ##color##        text_color = "#EDF2F4";
      ##color##        text_light = "#26272A";
      ##color##      };

      username = {
        style_user = "bold os";
        style_root = "bold os_admin";
        format = "[ $user](fg:$style) ";
        disabled = false;
        show_always = true;
      };

      os = {
        format = "on [($name)]($style) ";
        style = "bold blue";
        disabled = true;
        symbols = {
          Alpine = " ";
          Arch = " ";
          Debian = " ";
          EndeavourOS = " ";
          Fedora = " ";
          Linux = " ";
          Macos = " ";
          Manjaro = " ";
          Mint = " ";
          NixOS = " ";
          openSUSE = " ";
          Pop = " ";
          SUSE = " ";
          Ubuntu = " ";
          Windows = " ";
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
        read_only = "  ";
      };

      time = {
        disabled = true;
        format = "at [󱑈 $time]($style)";
        time_format = "%H:%M";
        style = "bold fg:time";
      };

      cmd_duration = {
        format = "took [ $duration]($style) ";
        style = "bold fg:duration";
        min_time = 500;
      };

      git_branch = {
        format = "via [$symbol$branch]($style) ";
        style = "bold fg:git";
        symbol = " ";
      };

      git_status = {
        format = "[ $all_status$ahead_behind ]($style)";
        style = "fg:text_color bg:git";
        disabled = true;
      };

      docker_context = {
        disabled = false;
        symbol = " ";
      };

      package.disabled = false;

      nodejs = {
        format = "[ $symbol$version ]($style)";
        style = "bg:node fg:text_light";
        symbol = " ";
        version_format = "\${raw}";
        disabled = false;
      };

      python = {
        disabled = false;
        format = "[ \${symbol}\${pyenv_prefix}(\${version})( \\($virtualenv\\)) ]($style)";
        symbol = " ";
        version_format = "\${raw}";
        style = "bg:python fg:text_light";
      };

      conda = {
        format = "[ $symbol$environment ]($style)";
        style = "bg:conda fg:text_light";
        ignore_base = false;
        disabled = false;
        symbol = " ";
      };

      java = {
        format = "[ $symbol$version ]($style)";
        style = "bg:java fg:text_light";
        version_format = "\${raw}";
        symbol = " ";
        disabled = true;
      };

      c = {
        format = "[ $symbol($version(-$name)) ]($style)";
        style = "bg:clang fg:text_light";
        symbol = " ";
        version_format = "\${raw}";
        disabled = false;
      };

      rust = {
        format = "[ $symbol$version ]($style)";
        style = "bg:rust fg:text_light";
        symbol = " ";
        version_format = "\${raw}";
        disabled = false;
      };
    };
  };
}
