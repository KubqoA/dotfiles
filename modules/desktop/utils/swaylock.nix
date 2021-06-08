{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.utils.swaylock;
  inherit (lib._) hexColor colors;
in {
  options.modules.desktop.utils.swaylock = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      swaylock
      physlock
      /* A slightly more secure screen-locking mechanism. Locks console switching
         and when the ‹swaylock› process finishes unlocks it. A more secure
         approach would be to only use ‹physlock›, but that has a few UI
         implications, I will maybe make in the future.
         ‹swaylock› must not use the ‹daemonize› option for this to work. The
         "daemonization" is done by the ‹&› operand.
      */
      (writeScriptBin "lock" ''
        #!${pkgs.stdenv.shell}
        doas physlock -l && (swaylock && doas physlock -L)&
      '')
    ];

    home.configFile."swaylock/config".text = let
      transparent = "#00000000";
    in ''
      indicator-radius=80
      indicator-x-position=100
      indicator-y-position=980
      hide-keyboard-layout
      image=${config.modules.desktop.swaywm.lockWallpaper}
      ring-color=${hexColor colors.gray._300}
      ring-clear-color=${hexColor colors.gray._300}
      ring-ver-color=${hexColor colors.gray._300}
      ring-wrong-color=${hexColor colors.red._300}
      key-hl-color=${hexColor colors.gray._300}
      bs-hl-color=${hexColor colors.red._300}

      text-color=${transparent}
      text-clear-color=${transparent}
      text-caps-lock-color=${transparent}
      text-ver-color=${transparent}
      text-wrong-color=${transparent}
      line-color=${transparent}
      line-clear-color=${transparent}
      line-caps-lock-color=${transparent}
      line-ver-color=${transparent}
      line-wrong-color=${transparent}
      inside-color=${transparent}
      inside-clear-color=${transparent}
      inside-ver-color=${transparent}
      inside-wrong-color=${transparent}
      separator-color=${transparent}
    '';
  };
}
