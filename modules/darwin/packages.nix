{lib, ...}: {
  imports = lib.imports ["nixos/packages"];

  homebrew = {
    brews = [
      "bitwarden-cli"
      "cmake"
      "coreutils"
      "gh"
      "mas"
      "mise"

      # newer version of CLIs present in MacOS
      "less"
      "openssh"

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
      "Home Assistant" = 1099568401;
    };
  };
}
