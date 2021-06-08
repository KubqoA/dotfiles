{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.onedrive;
  inherit (config.dotfiles) configDir;
in {
  options.modules.services.onedrive = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.onedrive.enable = true;

    home.configFile."onedrive/config".source = "${configDir}/onedrive/config";
    home.configFile."onedrive/sync_list".source = "${configDir}/onedrive/sync_list";
  };
}
