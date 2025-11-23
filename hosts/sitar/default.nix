{lib, ...}: {
  imports = lib.imports ["darwin/base"];

  my = {
    dock = [
      "/Applications/Zen.app"
      "/Applications/Ghostty.app"
      "/Applications/Cursor.app"
      "/Applications/Spotify.app"
      "/Applications/Slack.app"
      "/Applications/Notion.app"
    ];
    icons = {
      "/Applications/Beekeeper Studio.app" = ./icons/beekeeper-studio.icns;
      "/Applications/Logi Options.app" = ./icons/logi-options.icns;
      "/Applications/Notion.app" = ./icons/notion.icns;
      "/Applications/Spotify.app" = ./icons/spotify.icns;
      "/Applications/WireGuard.app" = ./icons/wireguard.icns;
    };
    uuid = "B1819449-1EB0-4B20-9148-5DBE2695842B";
  };

  system.keyboard = {
    enableKeyMapping = true;
    nonUS.remapTilde = true;
  };

  homebrew = {
    casks = [
      "beekeeper-studio"
      "httpie-desktop"
      "keyboardcleantool"
      "slack"
      "zed"
    ];

    masApps = {
      WireGuard = 1451685025;
    };
  };
}
