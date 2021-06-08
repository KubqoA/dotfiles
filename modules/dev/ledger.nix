{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.ledger;
in {
  options.modules.dev.ledger = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.dev.c.enable = true;

    user.packages = with pkgs; [
      ledger-udev-rules
    ];
  };
}
