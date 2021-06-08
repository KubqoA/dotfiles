{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.menu.nwggrid;
in {
  options.modules.desktop.apps.menu.nwggrid = {
    enable = _.mkBoolOpt false;
    executable = _.mkOpt' types.str "${pkgs.nwg-launchers}/bin/nwggrid";
  };

  config = mkIf cfg.enable {
    modules.desktop.apps.nwg-launchers.enable = true;
  };
}
