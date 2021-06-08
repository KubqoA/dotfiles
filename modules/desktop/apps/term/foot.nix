{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.term.foot;
in {
  options.modules.desktop.apps.term.foot = {
    enable = _.mkBoolOpt false;
    executable = _.mkOpt' types.str "${pkgs.foot}/bin/foot";
  };

  config = mkIf cfg.enable {
    user.packages = [
      pkgs.foot
    ];
  };
}
