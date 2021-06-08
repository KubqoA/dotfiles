{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.zathura;
  inherit (config.dotfiles) configDir;
in {
  options.modules.desktop.apps.zathura = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.zathura ];

    home.configFile."zathura/zathurarc".source = "${configDir}/zathura/zathurarc";
  };
}
