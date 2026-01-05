{lib, ...}: {
  imports = lib.imports ["darwin/base"];

  my = {
    dock = [
      "/Applications/Zen.app"
      "/Applications/Ghostty.app"
      "/Applications/Cursor.app"
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
      "valkey"
      "postgresql@18"
    ];

    casks = [
      "beekeeper-studio"
      "httpie-desktop"
      "keyboardcleantool"
      "notion-calendar"
      "slack"
      "zed"
    ];

    masApps = {
      WireGuard = 1451685025;
    };
  };
}
