# [home-manager]
{
  config,
  inputs,
  lib,
  system,
  ...
}: {
  options.programs.kitty = {
    darkTheme = lib.mkOption {
      type = lib.types.path;
      default = "${inputs.rose-pine-kitty}/dist/rose-pine.conf";
    };
    lightTheme = lib.mkOption {
      type = lib.types.path;
      default = "${inputs.rose-pine-kitty}/dist/rose-pine-dawn.conf";
    };
  };

  config = {
    programs.kitty = let
      mod =
        {
          "x86_64-linux" = "ctrl";
          "aarch64-linux" = "ctrl";
          "aarch64-darwin" = "cmd";
        }
        .${system};
    in {
      enable = true;
      extraConfig = ''
        font_size 12.0
        modify_font cell_height +6px

        map ${mod}+t no_op
        map ${mod}+c copy_to_clipboard
        map ${mod}+v paste_from_clipboard

        mouse_map ${mod}+left press ungrabbed,grabbed mouse_click_url

        confirm_os_window_close 0
        window_padding_width 10
        initial_window_width 640
        initial_window_height 400
        inactive_text_alpha 0.7
        macos_show_window_title_in none
        macos_titlebar_color background
        macos_quit_when_last_window_closed yes
        active_border_color none
        enable_audio_bell no

        # If current theme is not set, use the light theme
        include ${config.programs.kitty.lightTheme}
        include $HOME/.config/kitty_current_theme
      '';
    };

    theme = {
      dark.onSwitch = ''
        ln -sf "${config.programs.kitty.lightTheme}" "$HOME"/.config/kitty_current_theme
        pkill -USR1 kitty
      '';

      light.onSwitch = ''
        ln -sf "${config.programs.kitty.darkTheme}" "$HOME"/.config/kitty_current_theme
        pkill -USR1 kitty
      '';
    };
  };
}
