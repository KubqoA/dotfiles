{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.gtk;
in {
  options.modules.desktop.gtk = {
    enable = _.mkBoolOpt false;
    cursorTheme = {
      package = _.mkOpt' types.package pkgs.capitaine-cursors;
      name = _.mkOpt' types.str "capitaine-cursors";
      size = _.mkOpt' types.int 24;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cfg.cursorTheme.package gtk-engine-murrine ];

    # Fix gdk-pixbuf .svg bug
    environment.sessionVariables = {
      GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
    };

    home._.gtk = {
      enable = true;
      font.name = "SF Pro Display 11";
      gtk2.extraConfig = ''
        gtk-cursor-theme-name="${cfg.cursorTheme.name}"
        gtk-cursor-theme-size=${toString cfg.cursorTheme.size}
      '';
      gtk3.extraConfig = {
        gtk-cursor-theme-name = cfg.cursorTheme.name;
        gtk-cursor-theme-size = cfg.cursorTheme.size;
      };
      iconTheme.package = pkgs._.WhiteSur-icon-theme;
      iconTheme.name = "WhiteSur-icon-theme";
      theme.package = pkgs._.WhiteSur-gtk-theme;
      theme.name = "WhiteSur-gtk-theme-light";
    };

    home.file.".icons/default/index.theme".text = ''
      [icon theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=${cfg.cursorTheme.name}
    '';
  };
}
