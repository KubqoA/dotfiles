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

  homebrew = {
    brews = [
      "ripgrep"
      "gh"
      "mise"
      "bitwarden-cli"
      {
        name = "syncthing";
        restart_service = "changed";
      }
    ];

    casks = [
      "beekeeper-studio"
      "cursor"
      "figma"
      "ghostty"
      "httpie-desktop"
      "imaging-edge-webcam"
      "keyboardcleantool"
      "logitech-options"
      "monitorcontrol"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "slack"
      "spotify"
      "zed"
      "zen"
    ];

    masApps = {
      Bitwarden = 1352778147;
      WireGuard = 1451685025;
    };
  };
}
