{pkgs, ...}: {
  home = {
    packages = with pkgs; [brightnessctl wl-clipboard];

    # Hint Electron apps to use Wayland:
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 0;
      };

      decoration = {
        rounding = 8;
        # drop_shadow = true;
        # shadow_range = 10;
        # shadow_render_power = 2;
        # shadow_offset = "0.0 2.5";
        # "col.shadow" = "rgba(00000016)";
      };

      animations = {
        first_launch_animation = false;
        bezier = [
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "easeOutQuint, 0.22, 1, 0.36, 1"
        ];
        animation = [
          "windows, 0"
          "layers, 0"
          "fade, 0"
          "border, 0"
          "borderangle, 0"
          "workspaces, 1, 8, easeOutExpo"
        ];
      };

      exec-once = [
        "hyprlock"
      ];

      debug = {
        disable_logs = false;
      };

      input = {
        kb_layout = "us,sk";
        kb_options = "grp:win_space_toggle";
        kb_variant = ",qwerty";
        follow_mouse = true;
        touchpad = {
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_distance = 200;
      };

      windowrulev2 = [
        # fix pinentry losing focus
        "stayfocused,  class:^(pinentry-)"
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"
        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      monitor = [
        "eDP-1, 1920x1080@60.03300, 0x0, 1"
      ];
    };
  };
}
