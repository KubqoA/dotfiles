# System-level macOS settings, user preferences are managed by home-manager in `modules/hm/macos.nix`
{
  homes,
  lib,
  ...
}: let
  uuids = lib.filter (uuid: uuid != null) (map (home: home.config.my.uuid or null) homes);
in {
  system.defaults = {
    loginwindow = {
      DisableConsoleAccess = true;
      GuestEnabled = false;
    };
    CustomSystemPreferences = {
      "/var/root/Library/Preferences/com.apple.CoreBrightness.plist" =
        {
          "Keyboard Dim Time" = 30;
          KeyboardBacklight = {
            KeyboardBacklightABEnabled = true;
            KeyboardBacklightIdleDimTime = 30;
          };
        }
        // lib.mapToAttrs (uuid: {
          name = "CBUser-${uuid}";
          value.CBBlueReductionStatus = {
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
        })
        uuids;
    };
  };
}
