{
  config,
  self,
  ...
}: {
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
        "com.apple.trackpad.scaling" = 1.5;
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
