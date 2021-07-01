{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.chromium;
in {
  options.modules.desktop.apps.chromium = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (chromium.override {
        commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer";
      })
      (makeDesktopItem {
        name = "chromium-wayland";
        desktopName = "Chromium Wayland";
        genericName = "Open a wayland Chromium";
        icon = "chromium";
        exec = "${chromium}/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer";
        categories = "Network";
      })
    ];
  };
}
