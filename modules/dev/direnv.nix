{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.direnv;
in {
  options.modules.dev.direnv = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home._.programs.direnv = {
      enable = true;
      enableZshIntegration = config.modules.shell.zsh.enable;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
    };
  };
}
