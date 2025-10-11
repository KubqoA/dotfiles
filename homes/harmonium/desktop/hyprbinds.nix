{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = let
    terminal = "ghostty";
    swayosd-client = "${pkgs.swayosd}/bin/swayosd-client";
  in {
    "$mod" = "SUPER";

    # Mouse bindings.
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bind =
      [
        # Window/Session actions.
        "$mod, Q, killactive,"
        "$mod, W, fullscreen, 1"
        "$mode SHIFT, W, fullscreen,"
        "$mod, E, togglefloating,"
        "$mod, delete, exit,"

        # Dwindle
        "$mod, O, togglesplit,"
        "$mod, P, pseudo,"

        # Lock screen
        "$mod, Escape, exec, hyprlock"

        # Application shortcuts.
        "$mod, Return, exec, ${terminal}"
        "$mod SHIFT, Return, exec, ${terminal} --class floating"
        "$mod, F, exec, firefox"

        # Move window focus with vim keys.
        "$mod, h, movefocus, l"
        "$mod, h, bringactivetotop"
        "$mod, l, movefocus, r"
        "$mod, l, bringactivetotop"
        "$mod, k, movefocus, u"
        "$mod, k, bringactivetotop"
        "$mod, j, movefocus, d"
        "$mod, j, bringactivetotop"

        # Swap windows with vim keys
        "$mod SHIFT, h, swapwindow, l"
        "$mod SHIFT, l, swapwindow, r"
        "$mod SHIFT, k, swapwindow, u"
        "$mod SHIFT, j, swapwindow, d"

        # Move monitor focus.
        "$mod, TAB, focusmonitor, +1"
        "ALT, TAB, cyclenext"
        "ALT, TAB, bringactivetotop"

        # Switch workspaces.
        "$mod CTRL, h, workspace, r-1"
        "$mod CTRL, l, workspace, r+1"

        # Scroll through monitor workspaces with mod + scroll
        "$mod, mouse_down, workspace, r-1"
        "$mod, mouse_up, workspace, r+1"
        "$mod, mouse:274, killactive,"

        # Move active window to a workspace.
        "$mod CTRL SHIFT, l, movetoworkspace, r+1"
        "$mod CTRL SHIFT, h, movetoworkspace, r-1"

        # Control volume
        ", XF86AudioRaiseVolume, exec, ${swayosd-client} --output-volume raise"
        ", XF86AudioLowerVolume, exec, ${swayosd-client} --output-volume lower"
        ", XF86AudioMute, exec, ${swayosd-client} --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, ${swayosd-client} --input-volume mute-toggle"
        # Control brightness
        ", XF86MonBrightnessUp, exec, ${swayosd-client} --brightness raise"
        ", XF86MonBrightnessDown, exec, ${swayosd-client} --brightness lower"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (
            i: let
              ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

    bindl = [
      # Let kanshi handle lid closing
      ", switch:Lid Switch, exec, ${pkgs.kanshi}/bin/kanshictl reload"
    ];

    bindn = [
      ", Caps_Lock, exec, ${swayosd-client} --caps-lock"
    ];
  };
}
