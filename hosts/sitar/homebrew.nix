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
      "coreutils"
      "cmake"
      "fileicon"
      "ripgrep"
      "gh"
      "mise"
      "less" # update the default one shipped with macOS
      "bitwarden-cli"

      {
        name = "syncthing";
        restart_service = "changed";
      }
    ];

    casks = [
      "figma"
      "ghostty"
      "imaging-edge-webcam"
      "keyboardcleantool"
      "macmediakeyforwarder"
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
