{
  config,
  lib,
  system,
  ...
}: {
  imports =
    [
      ./homebrew.nix
      ./system.nix
    ]
    ++ lib.moduleImports [
      "common/nix"
      "common/packages"
      "darwin/icons"
    ];

  desktop.icons = {
    "/Applications/Beekeeper Studio.app" = ./icons/beekeeper-studio.icns;
    "/Applications/Capture One.app" = ./icons/capture-one.icns;
    "/Applications/Firefox Developer Edition.app" = ./icons/firefox-developer-edition.icns;
    "/Applications/Logi Options.app" = ./icons/logi-options.icns;
    "/Applications/Loom.app" = ./icons/loom.icns;
    "/Applications/MacMediaKeyForwarder.app" = ./icons/mac-media-key-forwarder.icns;
    "/Applications/Notion.app" = ./icons/notion.icns;
    "/Applications/Seadrive.app" = ./icons/seadrive.icns;
    "/Applications/Spotify.app" = ./icons/spotify.icns;
    "/Applications/Steam.app" = ./icons/steam.icns;
  };

  programs = {
    # home-manager on darwin doesn't support gpg-agent service, so it needs to be enabled here
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Necessary here to set correct PATH, configuration managed by home-manager
    zsh.enable = true;
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

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  users.users.${config.username}.home = config.homePath;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;
}
