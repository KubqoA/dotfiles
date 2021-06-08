{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.term.alacritty;
  colorscheme = config.modules.desktop.colorscheme.scheme.colors;
  inherit (config.dotfiles) configDir;
in {
  options.modules.desktop.apps.term.alacritty = {
    enable = _.mkBoolOpt false;
    executable = _.mkOpt' types.str "${pkgs.alacritty}/bin/alacritty";
  };

  config = mkIf cfg.enable {
    user.packages = [
      pkgs.alacritty
    ];
    home.configFile."alacritty/alacritty.yml".text = let
      config = builtins.readFile "${configDir}/alacritty/alacritty.yml";
      colors = ''
        colors:
          primary:
            background: #${colorscheme.background}
            foreground: #${colorscheme.foreground}
          normal:
            black: #${colorscheme.normal.black}
            red: #${colorscheme.normal.red}
            green: #${colorscheme.normal.green}
            yellow: #${colorscheme.normal.yellow}
            blue: #${colorscheme.normal.blue}
            magenta: #${colorscheme.normal.magenta}
            cyan: #${colorscheme.normal.cyan}
            white: #${colorscheme.normal.white}
          bright:
            black: #${colorscheme.bright.black}
            red: #${colorscheme.bright.red}
            green: #${colorscheme.bright.green}
            yellow: #${colorscheme.bright.yellow}
            blue: #${colorscheme.bright.blue}
            magenta: #${colorscheme.bright.magenta}
            cyan: #${colorscheme.bright.cyan}
            white: #${colorscheme.bright.white}
      '';
    in config;
  };
}
