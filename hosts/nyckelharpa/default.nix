{
  lib,
  pkgs,
  self,
  system,
  ...
}: {
  imports = [./homebrew.nix] ++ lib._.moduleImports ["common/nix"];

  networking.hostName = "nyckelharpa";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  programs = {
    # home-manager doesn't support gpg-agent service, so it needs to be enabled here
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Necessary here to set correct PATH, configuration managed by home-manager
    zsh.enable = true;
  };

  users.users.jakub.home = "/Users/jakub";

  security = {
    # Add ability to use Touch ID for sudo
    pam.enableSudoTouchIdAuth = true;
    sudo.extraConfig = ''
      Defaults timestamp_timeout=5
    '';
  };

  system = {
    defaults = {
      dock = {
        autohide-delay = 0.2;
        mineffect = "scale";
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/RubyMine.app"
          "/Applications/Cursor.app"
          "/Applications/Zed.app"
          "/Applications/iTerm.app"
          "/Applications/Notion.app"
          "/Applications/Slack.app"
          "/Applications/Obsidian.app"
          "/Applications/Spotify.app"
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
    };

    keyboard = {
      enableKeyMapping = true;
      nonUS.remapTilde = true;
    };

    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;
}
