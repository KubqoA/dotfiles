{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.openssh;
in {
  options.modules.services.openssh = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
