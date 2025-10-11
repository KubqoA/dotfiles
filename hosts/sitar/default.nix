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
      "/Applications/Notion.app" = ./icons/notion.icns;
      "/Applications/Spotify.app" = ./icons/spotify.icns;
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
      "imaging-edge-webcam"
      "keyboardcleantool"
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
  };
}
