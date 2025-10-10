{
  config,
  self,
  ...
}: let
  # User UUID, required by some settings
  # dscl /Search -read "/Users/$USER" GeneratedUID | cut -d ' ' -f2
  uuid = "B1819449-1EB0-4B20-9148-5DBE2695842B";
in {
  networking = {
    knownNetworkServices = ["Wi-Fi"];
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };

  system = {
    defaults = {
      dock = {
        autohide-delay = 0.2;
        mineffect = "scale";
        minimize-to-application = true;
        persistent-apps = [
          "/Applications/Zen.app"
          "/Applications/Ghostty.app"
          "/Applications/Cursor.app"
          "/Applications/Spotify.app"
          "/Applications/Slack.app"
          "/Applications/Notion.app"
        ];
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
          "CBUser-${uuid}" = {
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

    keyboard = {
      enableKeyMapping = true;
      nonUS.remapTilde = true;
    };

    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    primaryUser = config.username;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ os changelog
    stateVersion = 4;

    # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
    activationScripts.postActivation.text = ''
      echo "activating settings..."
      sudo -u ${config.username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
}
