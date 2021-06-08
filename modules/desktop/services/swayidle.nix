{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.services.swayidle;
in {
  options.modules.desktop.services.swayidle = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # TODO
  };
}