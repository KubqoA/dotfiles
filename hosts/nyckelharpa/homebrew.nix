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

      "puma/puma/puma-dev"

      # services
      {
        name = "postgresql@14";
        restart_service = "changed";
      }
      {
        name = "redis";
        restart_service = "changed";
      }
    ];

    casks = [
      "1password"
      "1password-cli"
      "arc"
      "around"
      "beekeeper-studio"
      "cursor"
      "figma"
      "firefox@developer-edition"
      "ghostty"
      "httpie"
      "intellij-idea-ce"
      "keyboardcleantool"
      "linearmouse"
      "loom"
      "macmediakeyforwarder"
      "monitorcontrol"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "rubymine"
      "slack"
      "spotify"
      "syncthing"
      "tailscale"
      "whatsapp"
      "zed"
      "zoom"
    ];
  };
}
