{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = lib._.moduleImports [
    "common/aliases"
    "common/env"
    "common/git"
    "common/neovim"
    "common/password-store"
  ];

  home = {
    username = "jakub";
    homeDirectory = "/home/jakub";
    packages = with pkgs; let
      python-with-dbus = pkgs.python3.withPackages (p: with p; [dbus-python]);
    in [
      home-manager
      chromium
      firefox
      zsh
      obsidian
      fzf

      # compositor utils
      glib # provides gsettings command
      swaybg
      hyprlock
      wl-clipboard

      # fonts
      ibm-plex

      # eduroam installler
      (writeShellScriptBin "install-eduroam-muni" "${python-with-dbus}/bin/python3 ${inputs.eduroam-muni}")
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  fonts.fontconfig.enable = true;

  xdg.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      startup = [
        {command = "swaybg -m fill -i ${./bg.jpg}";}
        {
          command = "systemctl --user restart kanshi.service";
          always = true;
        }
      ];
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
      in
        lib.mkOptionDefault {
          # Control volume
          XF86AudioRaiseVolume = "exec swayosd-client --output-volume raise";
          XF86AudioLowerVolume = "exec swayosd-client --output-volume lower";
          XF86AudioMute = "exec swayosd-client --output-volume mute-toggle";
          XF86AudioMicMute = "exec swayosd-client --input-volume mute-toggle";
          # Control brightness
          XF86MonBrightnessUp = "exec swayosd-client --brightness raise";
          XF86MonBrightnessDown = "exec swayosd-client --brightness lower";
          "${mod}+Control+h" = "workspace prev";
          "${mod}+Control+l" = "workspace next";
          "${mod}+Tab" = "workspace back_and_forth";
          "Mod1+l" = "exec hyprlock";
        };
      terminal = "foot";
      menu = "bemenu-run";
      gaps.inner = 30;
      window.titlebar = false;
      colors.focused = lib.mkOptionDefault {childBorder = lib.mkForce "#525252";};
    };
    extraConfig = ''
      bindsym --release Caps_Lock exec swayosd-client --caps-lock
      bindswitch lid:on output eDP-1 disable
      bindswitch lid:off output eDP-1 enable
    '';
    wrapperFeatures.base = true;
    wrapperFeatures.gtk = true;
  };

  programs.bemenu = {
    enable = true;
    settings = {
      b = true;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
  };

  # Shell
  # ZSH configured manually - move into dotfiles

  # Terminal
  programs.foot = {
    enable = true;
    settings = {
      main = {
        pad = "10x10";
        font = "IBM Plex Mono:size=10";
        line-height = 12;
      };

      # Rose-Piné Dawn (By cement-drinker)
      cursor.color = "faf4ed 575279";
      colors = {
        background = "faf4ed";
        foreground = "575279";
        regular0 = "f2e9e1"; # black (Overlay)
        regular1 = "b4637a"; # red (Love)
        regular2 = "31748f"; # green (Pine)
        regular3 = "ea9d34"; # yellow (Gold)
        regular4 = "56949f"; # blue (Foam)
        regular5 = "907aa9"; # magenta (Iris)
        regular6 = "d7827e"; # cyan (Rose)
        regular7 = "575279"; # white (Text)

        bright0 = "9893a5"; # bright black (Overlay)
        bright1 = "b4637a"; # bright red (Love)
        bright2 = "31748f"; # bright green (Pine)
        bright3 = "ea9d34"; # bright yellow (Gold)
        bright4 = "56949f"; # bright blue (Foam)
        bright5 = "907aa9"; # bright magenta (Iris)
        bright6 = "d7827e"; # bright cyan (Rose)
        bright7 = "575279"; # bright white (Text)
      };
    };
  };

  # Utilities
  programs.bat.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Services
  services.kanshi = {
    enable = true;
    profiles = {
      home = {
        outputs = [
          {
            criteria = "DP-2";
            mode = "3840x2160";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080";
            position = "3840,1080";
            scale = 1.0;
          }
        ];
        exec = "${pkgs.gnugrep}/bin/grep closed /proc/acpi/button/lid/LID/state && ${pkgs.kanshi}/bin/kanshictl switch home-only-external";
      };
      home-only-external = {
        outputs = [
          {
            criteria = "DP-2";
            mode = "3840x2160";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
      laptop = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "1920x1080";
            scale = 1.0;
          }
        ];
      };
    };
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 172800;
    maxCacheTtl = 172800;
    defaultCacheTtlSsh = 172800;
    maxCacheTtlSsh = 172800;
    pinentryPackage = pkgs.pinentry-bemenu;
    sshKeys = [config.gpgSshControl];
  };

  services.syncthing.enable = true;
  services.syncthing.tray.enable = false;

  services.swayosd = {
    enable = true;
    topMargin = 0.95;
    stylePath = ./swayosd.css;
  };

  services.dunst.enable = true;

  home.stateVersion = "24.05";
}
