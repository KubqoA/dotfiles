{lib, ...}: {
  imports = lib.imports ["darwin/base" "darwin/ruby"];

  my = {
    dock = [
      "/Applications/Helium.app"
      "/Applications/Ghostty.app"
      "/Applications/Zed.app"
      "/Applications/Spotify.app"
      "/Applications/WhatsApp.app"
    ];
    icons = {
      "/Applications/Steam.app" = ./icons/steam.icns;
    };
    uuid = "9A95453F-92B5-4C37-98FD-7809C8B7CE44";
  };

  # home-manager on darwin doesn't support gpg-agent service, so it needs to be enabled here
  programs.gnupg.agent.enable = true;

  homebrew = {
    brews = [
      "pinentry-mac"

      {
        name = "postgresql@18";
        restart_service = "changed";
      }
      {
        name = "mariadb";
        restart_service = "changed";
      }
      {
        name = "valkey";
        restart_service = "changed";
      }
    ];

    casks = [
      "google-chrome"
      "iina"
      "imaging-edge-webcam"
      "keyboardcleantool"
      "logi-options+"
      "private-internet-access"
      "steam"
      "whatsapp"
    ];
  };
}
