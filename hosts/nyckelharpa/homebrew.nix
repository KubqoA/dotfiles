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
      "homebrew/services"
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
      "arc"
      "bitwarden"
      "cursor"
      "figma"
      "ghostty"
      "httpie"
      "imaging-edge-webcam"
      "keyboardcleantool"
      "macmediakeyforwarder"
      "monitorcontrol"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "rubymine"
      "spotify"
      "syncthing"
      "tailscale"
      "whatsapp"
      "zed"
      "zen"
      "zoom"
    ];
  };
}
