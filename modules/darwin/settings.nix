{
  lib,
  config,
  ...
}: let
  cfg = config.my;
in {
  options.my = with lib; {
    uuid = mkOption {
      type = types.str;
      example = "9A95453F-92B5-4C37-98FD-7809C8B7CE44";
      description = ''
        User UUID, required by some settings.
        Obtain with `dscl /Search -read \"/Users/$USER\" GeneratedUID | cut -d ' ' -f2`
      '';
    };
    dock = mkOption {
      type = types.listOf types.str;
      example = ["/Applications/Zen.app" "/Applications/Spotify.app"];
      description = "Alias for system.defaults.dock.persistent-apps";
    };
  };

  config.system.defaults = {
    dock = {
      autohide-delay = 0.2;
      mineffect = "scale";
      minimize-to-application = true;
      persistent-apps = cfg.dock;
      persistent-others = [];
      show-recents = false;
      tilesize = 32;
    };
    loginwindow = {
      DisableConsoleAccess = true;
      GuestEnabled = false;
    };
    menuExtraClock = {
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
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 60;
    };
    trackpad = {
      Clicking = true;
    };
    CustomSystemPreferences = {
      "/var/root/Library/Preferences/com.apple.CoreBrightness.plist" = {
        "CBUser-${cfg.uuid}" = {
          CBBlueReductionStatus = {
            AutoBlueReductionEnabled = 1;
            BlueLightReductionAlgoOverride = 0;
            BlueLightReductionDisableScheduleAlertCounter = 3;
            BlueLightReductionSchedule = {
              DayStartHour = 7;
              DayStartMinute = 0;
              NightStartHour = 22;
              NightStartMinute = 0;
            };
            BlueReductionAvailable = 1;
            BlueReductionEnabled = 0;
            BlueReductionMode = 1;
            BlueReductionSunScheduleAllowed = true;
            Version = 1;
          };
        };
        "Keyboard Dim Time" = 30;
        KeyboardBacklight = {
          KeyboardBacklightABEnabled = true;
          KeyboardBacklightIdleDimTime = 30;
        };
      };
    };
  };
}
