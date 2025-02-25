{self, ...}: {
  system = {
    defaults = {
      dock = {
        autohide-delay = 0.2;
        mineffect = "scale";
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Ghostty.app"
          "/Applications/Cursor.app"
          "/Applications/Spotify.app"
          "/Applications/Slack.app"
          "/Applications/WhatsApp.app"
        ];
        show-recents = false;
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
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 60;
      };
      CustomUserPreferences = {
        "org.gpgtools.common" = {
          UseKeychain = true;
          DisableKeychain = true;
        };
      };
    };

    keyboard = {
      enableKeyMapping = true;
      nonUS.remapTilde = true;
    };

    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ os changelog
    stateVersion = 4;

    # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
    activationScripts.postUserActivation.text = ''
      echo "activating settings..."
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
}
