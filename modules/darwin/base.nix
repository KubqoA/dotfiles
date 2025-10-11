{
  config,
  lib,
  pkgs,
  self,
  system,
  ...
}: {
  imports = lib.imports [
    "darwin/icons"
    "darwin/nix"
    "darwin/packages"
    "darwin/settings"
  ];

  # Sensible Homebrew defaults
  environment.variables.HOMEBREW_NO_ANALYTICS = "1";
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    brews = [
      "cmake"
      "coreutils"
      "less" # update the default one shipped with macOS
    ];
  };

  # Necessary here to set correct PATH, configuration managed by home-manager
  programs.fish.enable = true;

  # Set the knownUsers so that the default shell works
  # https://github.com/LnL7/nix-darwin/issues/1237#issuecomment-2562230471
  users.knownUsers = [config.username];
  users.users.${config.username} = {
    home = config.homePath;
    shell = pkgs.fish;
    uid = 501;
  };

  security = {
    # Add ability to use Touch ID for sudo
    pam.services.sudo_local = {
      reattach = true;
      touchIdAuth = true;
    };
    sudo.extraConfig = ''
      Defaults timestamp_timeout=5
    '';
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  # Use 1.1.1.1 as DNS resolver
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
