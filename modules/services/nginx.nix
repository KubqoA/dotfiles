{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.nginx;
in {
  options.modules.services.nginx = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # TODO
  };
}