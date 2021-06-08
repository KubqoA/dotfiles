{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.firefox;
in {
  options.modules.desktop.apps.firefox = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home._.programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles.unacorda = {
        path = "unacorda";
        settings = {
          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffvpx.enabled" = false;
          "media.rdd-vpx.enabled" = false;
          "security.sandbox.content.level" = 0;
          "media.navigator.mediadatadecoder_vpx_enabled" = true;
        };
      };
    };
  };
}
