{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.vscode;
in {
  options.modules.desktop.apps.vscode = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs._.vscode-insiders ];
  };
}
