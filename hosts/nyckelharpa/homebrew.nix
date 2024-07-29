{...}: {
  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    brews = [
      "asdf"
      "gpg"
      "gpg2"
      "pass"
      "pass-otp"
      "pinentry-mac"
      "sqlite"
    ];

    casks = [
      "arc"
      "beekeeper-studio"
      "figma"
      "iterm2"
      "loom"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "spotify"
      "steam"
      "unnaturalscrollwheels" # Enable natural scrolling in the trackpad but regular scroll on an external mouse
      "visual-studio-code"
      "whatsapp"
      "zed"
    ];
  };
}
