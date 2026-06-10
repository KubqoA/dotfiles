{lib, ...}: {
  imports = lib.imports ["darwin/base"];

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
    taps = [
      "puma/puma"
    ];

    brews = [
      "pinentry-mac"
      {
        name = "libiconv";
        link = true;
      }

      # ruby building
      "autoconf"
      "gmp"
      "jemalloc"
      "libsodium"
      "libyaml"
      "openssl@3.5"
      "python-setuptools"
      "readline"
      "vips"

      # services
      "puma/puma/puma-dev"
      {
        name = "postgresql@18";
        restart_service = "changed";
      }
      {
        name = "mariadb";
        restart_service = "changed";
      }
      {
        name = "redis";
        restart_service = "changed";
      }
    ];

    casks = [
      "imaging-edge-webcam"
      "keyboardcleantool"
      "meld"
      "private-internet-access"
      "rubymine"
      "steam"
      "whatsapp"
      "zed"
      "zoom"
    ];
  };
}
