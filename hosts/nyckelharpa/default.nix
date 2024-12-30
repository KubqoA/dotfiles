{
  config,
  lib,
  pkgs,
  self,
  system,
  ...
}: {
  imports = [./homebrew.nix] ++ lib._.moduleImports ["common/nix" "common/packages"];

  networking.hostName = "nyckelharpa";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    monitorcontrol
  ];

  programs = {
    # home-manager doesn't support gpg-agent service, so it needs to be enabled here
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Necessary here to set correct PATH, configuration managed by home-manager
    zsh.enable = true;
  };

  users.users.${config.username}.home = "/Users/${config.username}";

  security = {
    # Add ability to use Touch ID for sudo
    pam.enableSudoTouchIdAuth = true;
    sudo.extraConfig = ''
      Defaults timestamp_timeout=5
    '';
  };

  launchd.daemons.tildeRemap = {
    serviceConfig = {
      Label = "tilde-remap";
      KeepAlive = false;
      RunAtLoad = true;
    };
    script = ''
      /usr/bin/hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}'
    '';
  };

  system = {
    defaults = {
      dock = {
        autohide-delay = 0.2;
        mineffect = "scale";
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Ghostty.app"
          "/Applications/RubyMine.app"
          "/Applications/Cursor.app"
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

    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ os changelog
    stateVersion = 4;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;
}
