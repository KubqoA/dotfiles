{lib, ...}: {
  imports = lib.imports ["nixos/packages"];

  homebrew = {
    brews = [
      "bitwarden-cli"
      "cmake"
      "coreutils"
      "gh"
      "less" # update the default one shipped with macOS
      "mise"

      {
        name = "syncthing";
        restart_service = "changed";
      }
    ];

    casks = [
      "cursor"
      "ghostty"
      "logitech-options"
      "monitorcontrol"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "spotify"
      "zen"
    ];

    masApps = {
      Bitwarden = 1352778147;
    };
  };
}
