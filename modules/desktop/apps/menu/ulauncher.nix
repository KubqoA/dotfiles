{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.menu.ulauncher;
in {
  options.modules.desktop.apps.menu.ulauncher = {
    enable = _.mkBoolOpt false;
    executable = _.mkOpt' types.str "${pkgs.ulauncher}/bin/ulauncher";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ ulauncher ];
  };
}
