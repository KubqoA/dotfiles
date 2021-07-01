{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.games;
in {
  options.modules.desktop.games = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
  };
}
