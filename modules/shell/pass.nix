{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.pass;
in {
  options.modules.shell.pass = {
    enable = _.mkBoolOpt false;
    passwordStoreDir = _.mkOpt' types.str "$XDG_DATA_HOME/password-store";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (pass-wayland.withExtensions (exts: [
        exts.pass-otp
        exts.pass-genphrase
      ]))
    ];

    env.PASSWORD_STORE_DIR = cfg.passwordStoreDir;
  };
}
