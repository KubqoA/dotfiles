{
  config,
  lib,
  pkgs,
  system,
  ...
}: {
  imports = lib.imports [
    ./homebrew.nix
    ./system.nix
    "common/nix"
    "common/packages"
    "darwin/icons"
  ];

  desktop.icons = {
    "/Applications/Capture One.app" = ./icons/capture-one.icns;
    "/Applications/Logi Options.app" = ./icons/logi-options.icns;
    "/Applications/Loom.app" = ./icons/loom.icns;
    "/Applications/MacMediaKeyForwarder.app" = ./icons/mac-media-key-forwarder.icns;
    "/Applications/Notion.app" = ./icons/notion.icns;
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
    fish.enable = true;
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

  # Set the knownUsers so that the default shell works
  # https://github.com/LnL7/nix-darwin/issues/1237#issuecomment-2562230471
  users.knownUsers = [config.username];
  users.users.${config.username} = {
    home = config.homePath;
    shell = pkgs.fish;
    uid = 501;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;
}
