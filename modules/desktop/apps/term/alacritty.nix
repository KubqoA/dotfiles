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
      config = "${configDir}/alacritty/alacritty.yml";
      colors = ''
        # Colors (One Light - https://github.com/atom/atom/tree/master/packages/one-light-syntax)
        colors:
          primary:
            background: '#fafafa'
            foreground: '#383a42'
          cursor:
            text:       CellBackground
            cursor:     '#526eff' # syntax-cursor-color
          selection:
            text:       CellForeground
            background: '#e5e5e6' # syntax-selection-color
          normal:
            black:      '#696c77' # mono-2
            red:        '#e45649' # red 1
            green:      '#50a14f'
            yellow:     '#c18401' # orange 2
            blue:       '#4078f2'
            magenta:    '#a626a4'
            cyan:       '#0184bc'
            white:      '#a0a1a7' # mono-3
        background_opacity: 1
      '';
      # colors = ''
      #   colors:
      #     primary:
      #       background: #${colorscheme.background}
      #       foreground: #${colorscheme.foreground}
      #     normal:
      #       black: #${colorscheme.normal.black}
      #       red: #${colorscheme.normal.red}
      #       green: #${colorscheme.normal.green}
      #       yellow: #${colorscheme.normal.yellow}
      #       blue: #${colorscheme.normal.blue}
      #       magenta: #${colorscheme.normal.magenta}
      #       cyan: #${colorscheme.normal.cyan}
      #       white: #${colorscheme.normal.white}
      #     bright:
      #       black: #${colorscheme.bright.black}
      #       red: #${colorscheme.bright.red}
      #       green: #${colorscheme.bright.green}
      #       yellow: #${colorscheme.bright.yellow}
      #       blue: #${colorscheme.bright.blue}
      #       magenta: #${colorscheme.bright.magenta}
      #       cyan: #${colorscheme.bright.cyan}
      #       white: #${colorscheme.bright.white}
      # '';
    in _.configWithExtras config colors;
  };
}
