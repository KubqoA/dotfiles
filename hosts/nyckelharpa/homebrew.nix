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
      "puma/puma" # for brews -> puma-dev
    ];

    brews = [
      "gpg"
      "gpg2"

      # work specific
      "rbenv"
      "ruby-build"
      "nodenv"
      "puma/puma/puma-dev"
      "libyaml"
      "libsodium"
      "vips"
      "python-setuptools"
      {
        name = "postgresql";
        restart_service = "changed";
      }
      {
        name = "redis";
        restart_service = "changed";
      }
    ];

    casks = [
      "bruno"
      "1password"
      "arc"
      "around"
      "beekeeper-studio"
      "betterdisplay"
      "figma"
      "intellij-idea-ce"
      "iterm2"
      "linearmouse"
      "loom"
      "logi-options-plus"
      "macmediakeyforwarder"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "rubymine"
      "spotify"
      "slack"
      "syncthing"
      "visual-studio-code"
      "whatsapp"
      "zed"
    ];
  };
}
