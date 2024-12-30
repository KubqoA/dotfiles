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
      "fileicon"

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
      "arc"
      "around"
      "beekeeper-studio"
      "cursor"
      "figma"
      "firefox@developer-edition"
      "ghostty"
      "intellij-idea-ce"
      "linearmouse"
      "loom"
      "macmediakeyforwarder"
      "monitorcontrol"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "rubymine"
      "seadrive"
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
