{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.hardware.graphics;
in {
  options.modules.hardware.graphics = {
    enable = _.mkBoolOpt false;
    vaapi = {
      enable = _.mkOpt types.bool false "Enable support for VA-API";
      package = _.mkOpt types.package pkgs.vaapiIntel "Package to use for VA-API";
      intelHybrid = _.mkOpt types.bool false "Whether to enable Intel Hybrid driver support for <package>vaapiIntel</package>";
    };
  };

  config = mkIf cfg.enable {
    hardware.opengl.enable = true;
    hardware.opengl.extraPackages = mkIf cfg.vaapi.enable [
      cfg.vaapi.package
    ];
    nixpkgs.config.packageOverrides = pkgs: mkIf cfg.vaapi.intelHybrid {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };
}
