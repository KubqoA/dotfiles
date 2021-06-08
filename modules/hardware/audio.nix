{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.hardware.audio;
  inherit (config.dotfiles) configDir;
in {
  options.modules.hardware.audio = {
    enable = _.mkBoolOpt false;
    pulseeffects.enable = _.mkOpt types.bool true "Enable support for pulseeffects";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
      user.extraGroups = [ "audio" ];
    }
    (mkIf cfg.pulseeffects.enable {
      home._.services.pulseeffects = {
        enable = true;
        package = pkgs.pulseeffects-pw;
      };
      home.configFile."PulseEffects/output/WH-1000XM3.json".source = "${configDir}/PulseEffects/WH-1000XM3.json";
    })
  ]);
}
