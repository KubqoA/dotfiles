{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.services.kanshi;
in {
  options.modules.desktop.services.kanshi = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home._.services.kanshi = {
      enable = true;
      profiles.default.outputs = [
        {
          criteria = "eDP-1";
          mode = "1920x1080";
          position = "0,0";
        }
      ];
      profiles.work.outputs = [
        {
          criteria = "eDP-1";
          mode = "1920x1080";
          position = "0,1080";
        }
        {
          criteria = "DP-2";
          mode = "1920x1080";
          position = "0,0";
        }
      ];
    };
  };
}
