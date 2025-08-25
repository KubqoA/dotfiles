{...}: {
  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "puma/puma"
    ];

    brews = [
      "coreutils"
      "cmake"
      "fileicon"
      "ripgrep"
      "gh"
      "mise"
      "pinentry-mac"
      "less" # update the default one shipped with macOS
      "bitwarden-cli"
      "ollama"

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
    ];

    casks = [
      "cursor"
      "figma"
      "ghostty"
      "httpie"
      "imaging-edge-webcam"
      "keyboardcleantool"
      "logitech-options"
      "macmediakeyforwarder"
      "monitorcontrol"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "spotify"
      "steam"
      "syncthing"
      "whatsapp"
      "zed"
      "zen"
      "zoom"
    ];
  };
}
