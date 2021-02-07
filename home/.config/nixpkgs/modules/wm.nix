{ config, lib, pkgs, ... }:

let
  enableSwayBorders = false;

  buildScript = import ../buildScript.nix;
  wallpaper = ../config/bg.jpg;
  lockScript = buildScript "lock" ../config/swaylock/lock {
    bg = wallpaper;
    lock = ../config/swaylock/lock.svg;
    swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  };
  import-gsettingsScript = buildScript "import-gsettings" ../config/import-gsettings {
    gsettings = "${pkgs.glib}/bin/gsettings";
  };
  theme = pkgs.callPackage ../pkgs/WhiteSur-gtk-theme {};
  iconTheme = pkgs.callPackage ../pkgs/WhiteSur-icon-theme {};
  cursor-theme-name = "capitaine-cursors";
  unstable = if enableSwayBorders then import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { } else null;
  sway-borders = if enableSwayBorders then import ../pkgs/sway-borders/default.nix unstable else null;
in
{
  home.packages = [ pkgs.ulauncher ];

  services.kanshi = {
    enable = true;
    profiles.default.outputs = [
      {
        criteria = "eDP-1";
        mode = "1920x1080";
        position = "0,0";
      }
    ];
  };

  programs.mako = {
    enable = true;
    anchor = "bottom-right";
    layer = "overlay";

    font = "SF Pro Display 11";

    backgroundColor = "#2D3748";
    progressColor = "source #718096";
    textColor = "#F7FAFC";
    padding = "15,20";
    margin = "0,10,10,0";

    borderSize = 0;
    borderRadius = 4;

    defaultTimeout = 10000;
#    extraConfig = ''
#      [urgency=high]
#      ignore-timeout=1
#      text-color=#742A2A
#      background-color=#FEB2B2
#      progress-color=source #FC8181
#    '';
  };

  home.file.".config/swaylock" = {
    source = ../config/swaylock;
    recursive = true;
  };

  gtk.enable = true;
  gtk.font.name = "SF Pro Display 11";
  gtk.gtk2.extraConfig = ''
    gtk-cursor-theme-name=${cursor-theme-name};
  '';
  gtk.gtk3.extraConfig = {
    gtk-cursor-theme-name = cursor-theme-name;
  };
  gtk.iconTheme.package = iconTheme;
  gtk.iconTheme.name = "WhiteSur-icon-theme";
  gtk.theme.package = theme;
  gtk.theme.name = "WhiteSur-gtk-theme-light";

  wayland.windowManager.sway = {
    enable = true;
    package = if enableSwayBorders then sway-borders else null;
    wrapperFeatures.gtk = true;
    config = {
      assigns = let
        assign = n: id: { "${toString n}" = [id]; };
      in
        assign 4 { class = "Spotify"; } //
        assign 9 { app_id = "zoom"; } //
        assign 10 { class = "Slack"; };
      bars = [{ command = "waybar"; }];
      fonts = [ "Font Awesome 5 Free 11" "SF Pro Display 11" ];
      gaps.inner = if enableSwayBorders then 25 else 20;
      input."type:keyboard" = {
        xkb_layout = "us,sk";
        xkb_variant = ",qwerty";
        xkb_options = "grp:alt_shift_toggle";
        xkb_numlock = "enabled";
      };
      input."type:touchpad" = {
        tap = "enabled";
        natural_scroll = "enabled";
        scroll_method = "two_finger";
      };
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        audio = "exec ${pkgs.pulseaudio-ctl}/bin/pulseaudio-ctl";
        playerctl = "exec ${pkgs.playerctl}/bin/playerctl";
        light = "exec ${pkgs.light}/bin/light";
        processScreenshot = ''${pkgs.wl-clipboard}/bin/wl-copy -t image/png && ${pkgs.libnotify}/bin/notify-send "Screenshot taken"'';
      in lib.mkOptionDefault {
        # Lock
        "Mod1+l" = "exec ${lockScript}/bin/lock";
        # Control volume
        XF86AudioRaiseVolume = "${audio} up";
        XF86AudioLowerVolume = "${audio} down";
        XF86AudioMute = "${audio} mute";
        XF86AudioMicMute = "${audio} mute-input";
        # Control media
        XF86AudioPlay = "${playerctl} play-pause";
        XF86AudioPause = "${playerctl} play-pause";
        XF86AudioNext = "${playerctl} next";
        XF86AudioPrev = "${playerctl} previous";
        # Control brightness
        XF86MonBrightnessUp = "${light} -A 10";
        XF86MonBrightnessDown = "${light} -U 10";
        # Screenshot
        "${mod}+Print" = ''exec ${pkgs.grim}/bin/grim - | ${processScreenshot}'';
        "${mod}+Shift+Print" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${processScreenshot}'';
        # Workspace 10
        "${mod}+0" = "workspace 10";
        "${mod}+Shift+0" = "move container to workspace 10";
        # Shortcuts for easier navigation between workspaces
        "${mod}+Control+Left" = "workspace prev";
        "${mod}+Control+Right" = "workspace next";
        "${mod}+Tab" = "workspace back_and_forth";
        # Exit sway
        "${mod}+Shift+e" = "exec ${pkgs.nwg-launchers}/bin/nwgbar -o 0.2";
      };
      menu = "${pkgs.ulauncher}/bin/ulauncher";
      modifier = "Mod4";
      output."*" = { bg = "${wallpaper} fill"; };
      startup = [
        { command = "${lockScript}/bin/lock a"; }
        { command = "${pkgs.autotiling}/bin/autotiling"; }
        { command = "${pkgs.ulauncher}/bin/ulauncher --hide-window"; }
      ];
      terminal = "${pkgs.alacritty}/bin/alacritty";
      window.border = 0;
      window.commands = let
        rule = command: criteria: { command = command; criteria = criteria; };
        floatingNoBorder = criteria: rule "floating enable, border none" criteria;
      in [
        (rule "floating enable, sticky enable, resize set 384 216, move position 1516 821" { app_id = "firefox"; title = "^Picture-in-Picture$"; })
        (rule "floating enable, resize set 1000 600" { app_id = "zoom"; title = "^(?!Zoom Meeting$)"; })
        (floatingNoBorder { class = "jetbrains-toolbox"; })
        (floatingNoBorder { class = "jetbrains.*"; title = "Welcome.*"; })
        (floatingNoBorder { class = "jetbrains.*"; title = "win0"; })
        (floatingNoBorder { app_id = "ulauncher"; })
        (rule "floating enable" { app_id = "onedrive_tray"; })
        (rule "floating enable" { class = "Tk"; })
      ];
    };
    extraConfig = ''
      seat seat0 xcursor_theme ${cursor-theme-name} 24
      exec_always ${import-gsettingsScript}/bin/import-gsettings
    '' + (if enableSwayBorders then ''
      border_images.focused ${../config/border.png}
      border_images.focused_inactive ${../config/border.png}
      border_images.unfocused ${../config/border.png}
      border_images.urgent ${../config/border.png}
    '' else "");
    extraSessionCommands = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      export MOZ_ENABLE_WAYLAND=1
      export CLUTTER_BACKEND=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export ECORE_EVAS_ENGINE=wayland-egl
      export ELM_ENGINE=wayland_egl
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export NO_AT_BRIDGE=1
      export SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh
    '';
  };

# services.wlsunset = {
  services.gammastep = {
    enable = true;
    latitude = "48.91";
    longitude = "18.05";
    temperature.night = 4500;
  };
}
