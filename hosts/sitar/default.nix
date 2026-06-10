{lib, ...}: {
  imports = lib.imports ["darwin/base"];

  my = {
    dock = [
      "/Applications/Helium.app"
      "/Applications/Ghostty.app"
      "/Applications/Zed.app"
      "/Applications/Spotify.app"
      "/Applications/Slack.app"
    ];
    icons = {
      "/Applications/Logi Options.app" = ./icons/logi-options.icns;
      "/Applications/WireGuard.app" = ./icons/wireguard.icns;
    };
    uuid = "B1819449-1EB0-4B20-9148-5DBE2695842B";
  };

  system.keyboard = {
    enableKeyMapping = true;
    nonUS.remapTilde = true;
  };

  homebrew = {
    brews = [
      "shfmt"

      "postgresql@18"
      "valkey"
    ];

    casks = [
      "beekeeper-studio"
      "httpie-desktop"
      "keyboardcleantool"
      "slack"
    ];

    masApps = {
      WireGuard = 1451685025;
    };
  };
}
