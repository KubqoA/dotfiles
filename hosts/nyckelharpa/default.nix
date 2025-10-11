{lib, ...}: {
  imports = lib.imports ["darwin/base"];

  my = {
    dock = [
      "/Applications/Zen.app"
      "/Applications/Ghostty.app"
      "/Applications/Zed.app"
      "/Applications/Spotify.app"
    ];
    icons = {
      "/Applications/Notion.app" = ./icons/notion.icns;
      "/Applications/Spotify.app" = ./icons/spotify.icns;
      "/Applications/Steam.app" = ./icons/steam.icns;
    };
    uuid = "9A95453F-92B5-4C37-98FD-7809C8B7CE44";
  };

  # home-manager on darwin doesn't support gpg-agent service, so it needs to be enabled here
  programs.gnupg.agent.enable = true;

  homebrew = {
    taps = [
      "puma/puma"
    ];

    brews = [
      "ripgrep"
      "gh"
      "mise"
      "pinentry-mac"
      "bitwarden-cli"

      # ruby building
      "autoconf"
      "gmp"
      "jemalloc"
      "libsodium"
      "libyaml"
      "openssl@3"
      "python-setuptools"
      "readline"
      "vips"

      # services
      "puma/puma/puma-dev"
      {
        name = "postgresql@17";
        restart_service = "changed";
      }
      {
        name = "redis";
        restart_service = "changed";
      }
      {
        name = "syncthing";
        restart_service = "changed";
      }
    ];

    casks = [
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
      "rubymine"
      "slack"
      "spotify"
      "steam"
      "whatsapp"
      "zed"
      "zen"
      "zoom"

      {
        name = "Sikarugir-App/sikarugir/sikarugir";
        args = {no_quarantine = true;};
      }
    ];
  };
}
