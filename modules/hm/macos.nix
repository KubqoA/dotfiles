# macOS user preferences, managed by home-manager so that every user on a host gets them,
# nix-darwin's `system.defaults` only apply to `system.primaryUser`.
# System-level settings live in `modules/darwin/settings.nix`.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my;

  dock = {
    autohide-delay = 0.2;
    mineffect = "scale";
    minimize-to-application = true;
    persistent-apps =
      map (app: {
        tile-data.file-data = {
          _CFURLString = app;
          _CFURLStringType = 0;
        };
      })
      cfg.dock;
    persistent-others = [];
    show-recents = false;
    tilesize = 32;
  };
  trackpad.Clicking = true;
in {
  options.my = with lib; {
    dock = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["/Applications/Zen.app" "/Applications/Spotify.app"];
      description = "Apps pinned to the dock";
    };
    uuid = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "9A95453F-92B5-4C37-98FD-7809C8B7CE44";
      description = ''
        User UUID, used by the darwin host config for per-user system settings (Night Shift).
        Obtain with `dscl /Search -read "/Users/$USER" GeneratedUID | cut -d ' ' -f2`
      '';
    };
  };

  config = {
    targets.darwin.defaults = {
      "com.apple.menuextra.clock" = {
        Show24Hour = true;
        ShowDate = 0;
        ShowDayOfWeek = true;
      };
      NSGlobalDomain = {
        "com.apple.trackpad.scaling" = 1.5; # trackpad speed
        AppleInterfaceStyleSwitchesAutomatically = true; # automatically switch between light and dark mode
        ApplePressAndHoldEnabled = false; # disable accented characters pop-up
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
      "com.apple.screensaver" = {
        askForPassword = true;
        askForPasswordDelay = 60;
      };
      "com.apple.AppleMultitouchTrackpad" = trackpad;
      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = trackpad;
      # Avoid creating .DS_Store files on network or USB volumes
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      # Save screenshots to clipboard by default
      "com.apple.screencapture".target = "clipboard";
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
    };

    # Apply the preferences without having to log out
    # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
    home.activation.activateSettings = lib.hm.dag.entryAfter ["setDarwinDefaults"] ''
      run /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    # The Dock isn't set by targets.darwin.defaults: a running Dock saves its own layout when apps change
    # (e.g. during copyApps) or when it quits, overwriting the imported one. So import right before
    # restarting it, and SIGKILL it so it can't save on quit, launchd starts it again.
    home.activation.restartDock = lib.hm.dag.entryAfter ["setDarwinDefaults" "copyApps"] ''
      run /usr/bin/defaults import com.apple.dock ${pkgs.writeText "com.apple.dock.plist" (lib.generators.toPlist {escape = true;} dock)}
      run /usr/bin/killall -KILL Dock || true
    '';
  };
}
