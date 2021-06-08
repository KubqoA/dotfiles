/*
    _____      ____ _ _   _ 
   / __\ \ /\ / / _` | | | |
   \__ \\ V  V / (_| | |_| |
   |___/ \_/\_/ \__,_|\__, |
                      |___/ 
   
   My main WM, runs on Wayland. Enabling this module, implicitly enables:
    → the chosen terminal, by default ‹modules.desktop.apps.term.foot›
    → the chosen application launcher, by default ‹modules.desktop.apps.menu.nwggrid›
    → light via ‹programs.light›
    → swaylock via ‹modules.desktop.utils.swaylock›
    → kanshi via ‹modules.desktop.services.kanshi›
    → mako via ‹modules.desktop.services.mako›
    → swayidle via ‹modules.desktop.services.swayidle›
    → waybar via ‹modules.desktop.services.waybar›
*/

{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.swaywm;
  audioSupport = config.modules.hardware.audio.enable;
  import-gsettings = _.buildBinScript "import-gsettings";
  inherit (config.dotfiles) binDir;
in {
  options.modules.desktop.swaywm = {
    enable = _.mkBoolOpt false;
    term = _.mkOpt types.str "foot" "Default terminal to run.";
    menu = _.mkOpt types.str "nwggrid" "Default menu to launch apps";
    wallpaper = _.mkOpt' (types.either types.str types.path) "";
    lockWallpaper = _.mkOpt' (types.either types.str types.path) "";
  };

  config = mkIf cfg.enable {
    # Enable sway itself, with few extra packages
    programs.sway = {
      enable = true;
      # remove dmenu and rxvt-unicode from extraPackages
      extraPackages = with pkgs; [ xwayland gsettings_desktop_schemas ];
    };

    user.packages = with pkgs; mkMerge [
      # Basic
      [ swaybg autotiling glib import-gsettings ]
      # Extra utils used in keybindings
      [ grim slurp wl-clipboard libnotify light ]
      # Include audio utils if audio is enabled
      ( mkIf audioSupport [ pulseaudio playerctl ] )
    ];

    # Enable backlight control and the user to the ‹video› group, which
    # enables controlling the backlight
    programs.light.enable = true;
    user.extraGroups = [ "video" ];

    # Implicitly enable the chosen terminal and menu, and enable swaylock
    modules.desktop.apps.term.${cfg.term}.enable = true;
    modules.desktop.apps.menu.${cfg.menu}.enable = true;
    modules.desktop.utils.swaylock.enable = true;

    # Also enable waybar, mako, swayidle
    modules.desktop.services.kanshi.enable = true;
    modules.desktop.services.mako.enable = true;
    modules.desktop.services.swayidle.enable = true;
    modules.desktop.services.waybar.enable = true;

    # For screencast support
    xdg.portal.enable = true;

    # Setup the sway config using home-manager
    home._.wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        assigns = let
          assign = n: id: { "${toString n}" = [id]; };
        in
          assign 4 { class = "Spotify"; } //
          assign 9 { app_id = "zoom"; } //
          assign 10 { class = "Slack"; };
        bars = [{ command = "waybar"; }];
        fonts = {
          names = [ "Font Awesome 5 Free" "SF Pro Display" ];
          size = 11.0;
        };
        gaps.inner = 20;
        input."type:keyboard" = {
          xkb_layout = "us,sk";
          xkb_variant = ",qwerty";
          xkb_options = "grp:alt_caps_toggle";
          xkb_numlock = "enabled";
        };
        input."type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
        };
        keybindings = let
          mod = config.home._.wayland.windowManager.sway.config.modifier;
          processScreenshot = ''wl-copy -t image/png && notify-send "Screenshot taken"'';
        in lib.mkOptionDefault {
          # Lock
          "Mod1+l" = "exec lock";
          # Control volume
          XF86AudioRaiseVolume = mkIf audioSupport "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
          XF86AudioLowerVolume = mkIf audioSupport "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
          XF86AudioMute = mkIf audioSupport "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          XF86AudioMicMute = mkIf audioSupport "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          # Control media
          XF86AudioPlay = mkIf audioSupport "exec playerctl play-pause";
          XF86AudioPause = mkIf audioSupport "exec playerctl play-pause";
          XF86AudioNext = mkIf audioSupport "exec playerctl next";
          XF86AudioPrev = mkIf audioSupport "exec playerctl previous";
          # Control brightness
          XF86MonBrightnessUp = "exec light -A 10";
          XF86MonBrightnessDown = "exec light -U 10";
          # Screenshot
          "${mod}+Print" = ''exec grim - | ${processScreenshot}'';
          "${mod}+Shift+Print" = ''exec grim -g "$(slurp -d)" - | ${processScreenshot}'';
          # Workspace 10
          "${mod}+0" = "workspace 10";
          "${mod}+Shift+0" = "move container to workspace 10";
          # Shortcuts for easier navigation between workspaces
          "${mod}+Control+Left" = "workspace prev";
          "${mod}+Control+Right" = "workspace next";
          "${mod}+Tab" = "workspace back_and_forth";
          # Exit sway
          "${mod}+Shift+e" = "exec nwgbar -o 0.2";
        };
        menu = config.modules.desktop.apps.menu.${cfg.menu}.executable;
        modifier = "Mod4";
        output."*" = { bg = "${cfg.wallpaper} fill"; };
        startup = [
          { command = "lock"; }
          { command = "autotiling"; }
          #{ command = "${udiskie}/bin/udiskie -s --appindicator --menu-update-workaround -f ${pkgs.pcmanfm}/bin/pcmanfm"; }
          { command = "import-gsettings"; always = true; }
          { command = "mako"; }
        ];
        terminal = config.modules.desktop.apps.term.${cfg.term}.executable;
        window.border = 0;
        window.commands = let
          rule = command: criteria: { command = command; criteria = criteria; };
          floatingNoBorder = criteria: rule "floating enable, border none" criteria;
        in [
          (rule "floating enable, sticky enable, resize set 384 216, move position 1516 821" { app_id = "firefox"; title = "^Picture-in-Picture$"; })
          (rule "floating enable, resize set 1000 600" { app_id = "zoom"; title = "^(?!Zoom Meeting$)"; })
          (floatingNoBorder { app_id = "ulauncher"; })
        ];
      };
      extraConfig = ''
        seat seat0 xcursor_theme "${config.modules.desktop.gtk.cursorTheme.name}" ${toString config.modules.desktop.gtk.cursorTheme.size}
      '';
    };
  };
}
