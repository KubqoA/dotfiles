{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.colorscheme.scheme;
  color = x: _.mkOpt types.str x null;
in {
  options.modules.desktop.colorscheme.scheme = {
    enable = _.mkBoolOpt false;
    colors = {
      background = color "0f0b0a";
      foreground = color "f9fafb";
      normal = {
        black = color "1d1f21";
        red = color "cc6666";
        green = color "b5bd68";
        yellow = color "f0c674";
        blue = color "81a2be";
        magenta = color "b294bb";
        cyan = color "8abeb7";
        white = color "c5c8c6";
      };
      bright = {
        black = color "666666";
        red = color "d54e53";
        green = color "b9ca4a";
        yellow = color "e7c547";
        blue = color "7aa6da";
        magenta = color "c397d8";
        cyan = color "70c0b1";
        white = color "eaeaea";
      };
    };
  };
}
