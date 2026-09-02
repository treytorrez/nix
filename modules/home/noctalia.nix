{ config, ... }:
{
  programs.noctalia = {
    enable = true;

    # Noctalia's systemd user service. This is a module option, not a key
    # inside the generated Noctalia settings.toml.
    systemd.enable = true;

    settings = {
      audio.enable_sounds = true;

      bar = {
        order = [ "default" ];
        default = {
          border = "primary";
          capsule = true;
          capsule_radius = 10;
          capsule_thickness = 0.99999998137354851;
          center = [ "clock" "media" ];
          end = [ "tray" "notifications" "clipboard" "network" "bluetooth" "volume" "battery" "control-center" "session" ];
          margin_edge = 0;
          margin_ends = 0;
          radius = 8;
          shadow = false;
          start = [ "launcher" "workspaces" "bar" ];
          thickness = 25;
        };
      };

      control_center.shortcuts = [
        { type = "wifi"; }
        { type = "bluetooth"; }
        { type = "caffeine"; }
        { type = "nightlight"; }
        { type = "notification"; }
      ];

      desktop_widgets.enabled = false;
      location.address = "Flagstaff, AZ";

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@HDMI-A-1"
          "lockscreen-login-box@eDP-1"
          "lockscreen-login-box@eDP-2"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@HDMI-A-1" = {
            box_height = 196.0;
            box_width = 720.0;
            cx = 960.0;
            cy = 961.0;
            output = "HDMI-A-1";
            placement_height = 0.0;
            placement_width = 0.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
          "lockscreen-login-box@eDP-1" = {
            box_height = 196.0;
            box_width = 720.0;
            cx = 800.0;
            cy = 881.0;
            output = "eDP-1";
            placement_height = 0.0;
            placement_width = 0.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
          "lockscreen-login-box@eDP-2" = {
            box_height = 196.0;
            box_width = 720.0;
            cx = 800.0;
            cy = 881.0;
            output = "eDP-2";
            placement_height = 1000.0;
            placement_width = 1600.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
        };
      };

      notification = {
        enable_daemon = false;
        layer = "overlay";
      };

      plugins.enabled = [ "noctalia/timer" ];

      shell = {
        avatar_path = "${config.home.homeDirectory}/Pictures/ILMC/delete.png";
        polkit_agent = true;
        panel.shadow = false;
      };

      theme = {
        builtin = "Gruvbox";
        community_palette = "Monochrome";
        mode = "dark";
        source = "builtin";
        wallpaper_scheme = "m3-content";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };

      wallpaper = {
        enabled = false;
        fill_color = "on_surface";
        fill_mode = "center";
        default.path = "${config.home.homeDirectory}/Pictures/Wallpapers/delete.png";
        last.path = "${config.home.homeDirectory}/Pictures/Wallpapers/delete.png";
        monitors.eDP-2.path = "${config.home.homeDirectory}/Pictures/Wallpapers/delete.png";
        favorite = [
          {
            builtin_palette = "Gruvbox";
            palette_source = "builtin";
            path = "${config.home.homeDirectory}/Pictures/Wallpapers/delete.png";
            theme_mode = "dark";
          }
          {
            palette_source = "wallpaper";
            path = "${config.home.homeDirectory}/Pictures/Wallpapers/fuck-my-computer.png";
            theme_mode = "dark";
            wallpaper_scheme = "m3-content";
          }
        ];
      };

      widget = {
        audio_visualizer = {
          bands = 10;
          color_2 = "tertiary";
          mirrored = false;
          scale = 1.2;
          width = 17;
        };
        bar = {
          show_idle_on_horizontal = false;
          type = "noctalia/timer:bar";
        };
        brightness = {
          color = "secondary";
          show_label = false;
        };
        workspaces = {
          minimal = true;
          occupied_color = "tertiary";
        };
      };

      launch_apps_as_systemd_services = true;
    };
  };
}
