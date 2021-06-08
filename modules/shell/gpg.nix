{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.gpg;
in {
  options.modules.shell.gpg = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home._.programs.gpg.enable = true;
    home._.services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 172800;
      maxCacheTtl = 172800;
      defaultCacheTtlSsh = 172800;
      maxCacheTtlSsh = 172800;
      pinentryFlavor = "qt";
      extraConfig = "display :0";
    };
  };
}
