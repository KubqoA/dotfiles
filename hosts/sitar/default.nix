{lib, ...}: {
  imports = lib.imports ["darwin/base"];

  my.icons = {
    "/Applications/Logi Options.app" = ./icons/logi-options.icns;
    "/Applications/WireGuard.app" = ./icons/wireguard.icns;
  };

  system.keyboard = {
    enableKeyMapping = true;
    nonUS.remapTilde = true;
  };

  homebrew = {
    brews = [
      "shfmt"

      "postgresql@18"
      "valkey"
    ];

    casks = [
      "beekeeper-studio"
      "httpie-desktop"
      "keyboardcleantool"
      "logitech-options"
      "notion-calendar"
      "slack"
    ];

    masApps = {
      WireGuard = 1451685025;
    };
  };
}
