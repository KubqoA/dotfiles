{lib, ...}: {
  imports = lib.imports ["nixos/packages"];

  homebrew = {
    brews = [
      "bitwarden-cli"
      "cmake"
      "coreutils"
      "dive"
      "gh"
      "httpie"
      "mas"
      "mise"

      # newer version of CLIs present in MacOS
      "less"
      "openssh"

      # AI
      "anomalyco/tap/opencode"
      "rtk"

      {
        name = "syncthing";
        restart_service = "changed";
      }
    ];

    casks = [
      "ghostty"
      "helium-browser"
      "macmediakeyforwarder"
      "monitorcontrol"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "spotify"
      "zed"
      "zen"

      # AI
      "claude-code@latest"
      "claude"

      "codex"
      "codex-app"
    ];

    masApps = {
      Bitwarden = 1352778147;
      "Home Assistant" = 1099568401;
    };
  };
}
