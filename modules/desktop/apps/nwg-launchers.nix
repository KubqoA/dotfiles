{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.nwg-launchers;
  inherit (config.dotfiles) configDir;
  inherit (lib._) colors hexColor;
in {
  options.modules.desktop.apps.nwg-launchers = {
    enable = _.mkBoolOpt false;
    nwgbar.colors = {
      background = {
        normal = _.mkOpt' types.str colors.gray._200;
        hover = _.mkOpt' types.str colors.gray._300;
      };
      text = _.mkOpt' types.str colors.gray._700;
      icon = _.mkOpt' types.str colors.gray._800;
    };
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.nwg-launchers ];

    home.configFile = let
      iconFiles = builtins.readDir "${configDir}/nwg-launchers/nwgbar/icons";
      colorizeIcon = icon: builtins.replaceStrings [ "currentcolor" ] [ (hexColor cfg.nwgbar.colors.icon) ] (builtins.readFile icon);
      colorizedIcons = mapAttrs' (icon: _: nameValuePair
        "nwg-launchers/nwgbar/icons/${icon}"
        { text = colorizeIcon "${configDir}/nwg-launchers/nwgbar/icons/${icon}"; }
      ) iconFiles;
    in mkMerge [
      colorizedIcons
      {
        "nwg-launchers/nwgbar/bar.json".source = "${configDir}/nwg-launchers/nwgbar/bar.json";
        "nwg-launchers/nwgbar/style.css".text = let
          colors = ''
            grid {
              background: ${hexColor cfg.nwgbar.colors.background.normal};
            }
            button:hover, button:focus {
              background-color: ${hexColor cfg.nwgbar.colors.background.hover};
            }
            button {
              color: ${hexColor cfg.nwgbar.colors.text};
            }
          '';
        in _.configWithExtras "${configDir}/nwg-launchers/nwgbar/style.css" colors;
      }
    ];
  };
}
