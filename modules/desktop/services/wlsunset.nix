{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.services.wlsunset;
in {
  options.modules.desktop.services.wlsunset = {
    enable = _.mkBoolOpt false;
    latitude = _.mkOpt types.str "48.9" "Your current latitude, between -90.0 and 90.0.";
    longitude = _.mkOpt types.str "18.0" "Your current longitude, between -180.0 and 180.0.";
    temperature.night = _.mkOpt types.int 4500 "Colour temperature to use during the night, in Kelvin (K).";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name}.services.wlsunset = {
      enable = true;
      latitude = cfg.latitude;
      longitude = cfg.longitude;
      temperature.night = cfg.temperature.night;
    };
  };
}
