{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.mpv;
  hardwareAcceleration = config.modules.hardware.graphics.vaapi.enable;
in {
  options.modules.desktop.apps.mpv = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home._.programs.mpv = {
      enable = true;
      bindings = {
        "ALT+k" = "add sub-scale +0.1";
        "ALT+j" = "add sub-scale -0.1";
        "ALT+=" = "add video-zoom +0.1";
        "ALT+-" = "add video-zoom -0.1";
      };
      config = {
        gpu-context = "wayland";
        save-position-on-quit = true;
        ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
        profile = mkIf hardwareAcceleration "gpu-hq";
        hwdec = mkIf hardwareAcceleration "auto-safe";
        vo = mkIf hardwareAcceleration "gpu";
      };
    };
  };
}
