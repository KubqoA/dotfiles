{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.networkmanager;
in {
  options.modules.services.networkmanager = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      networkmanager_openvpn
    ];

    user.extraGroups = [ "networkmanager" ];

    networking.networkmanager = {
      enable = true;
      insertNameservers = [ "1.1.1.1" "1.0.0.1" ];
    };
  };
}
