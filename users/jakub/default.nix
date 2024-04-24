{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home = {
    username = "jakub";
    homeDirectory = "/home/jakub";
    packages = with pkgs; let
      python-with-dbus = pkgs.python3.withPackages (p: with p; [dbus-python]);
    in [
      home-manager
      chromium
      firefox
      pass
      git
      zsh
      obsidian
      fzf

      # compositor utils
      glib # provides gsettings command
      swaybg
      hyprlock
      dunst

      # eduroam installler
      (writeShellScriptBin "install-eduroam-muni" "${python-with-dbus}/bin/python3 ${inputs.eduroam-muni}")
    ];
  };

  xdg.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      startup = [
        {command = "swaybg -m fill -i ${./bg.jpg}";}
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
          "${mod}+Control+l" = "workspace prev";
          "${mod}+Control+h" = "workspace next";
          "${mod}+Tab" = "workspace back_and_forth";
        };
      terminal = "foot";
      gaps.inner = 30;
      window.titlebar = false;
      colors.focused = lib.mkOptionDefault {childBorder = lib.mkForce "#525252";};
    };
    extraConfig = ''
      bindsym --release Caps_Lock exec swayosd-client --caps-lock
      #bindswitch lid:on output eDP-1 disable
      #bindswitch lid:off output eDP-1 enable
    '';
    wrapperFeatures.base = true;
    wrapperFeatures.gtk = true;
  };
  services.swayosd.enable = true;

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
  programs.foot.enable = true;

  # Editor
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraLuaConfig = lib.readFile ./init.lua;
    plugins = let
      vim-bind = pkgs.vimUtils.buildVimPlugin {
        name = "vim-bind";
        src = pkgs.fetchFromGitHub {
          owner = "Absolight";
          repo = "vim-bind";
          rev = "4967dc658b50d71568f9f80fce2d27e6a4698fc5";
          sha256 = "0hif1r329i5mylgkcb24dl1xcn287fvy7hpfln3whv8bwmphfc77";
        };
      };
      hyprland-vim-syntax = pkgs.vimUtils.buildVimPlugin {
        name = "hyprland-vim-syntax";
        src = pkgs.fetchFromGitHub {
          owner = "theRealCarneiro";
          repo = "hyprland-vim-syntax";
          rev = "71760fe0cad972070657b0528f48456f7e0027b2";
          sha256 = "08lpa1q4m52xnhd9a017q6xnl5pagjsvdfiv0z5gsv55msz86mw6";
        };
      };
    in
      with pkgs.vimPlugins; [
        impatient-nvim # speeds up loading Lua modules
        vim-vinegar # better netrw
        vim-commentary # easier commenting
        onenord-nvim # theme
        vim-bind # better bind zone higlighting
        hyprland-vim-syntax

        (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-clojure
            tree-sitter-fennel
            tree-sitter-haskell
            tree-sitter-json
            tree-sitter-lua
            tree-sitter-markdown
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
            tree-sitter-typescript
            tree-sitter-yaml
          ]))

        nvim-lspconfig
      ];
  };

  # Utilities
  programs.bat.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.password-store = {
    enable = true;
    # package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };

  # Services
  services.kanshi = {
    enable = true;
    profiles = {
      laptop = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080";
            scale = 1.0;
          }
        ];
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
      #home = {
      #  outputs = [
      #    {
      #      criteria = "DP-2";
      #      mode = "3840x2160";
      #      position = "0,0";
      #      scale = 1.0;
      #    }
      #    {
      #      criteria = "eDP-1";
      #      mode = "1920x1080";
      #      position = "3840,1080";
      #      scale = 1.0;
      #    }
      #  ];
      #};
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
    sshKeys = ["CC54AAD6EF69F323DEB5CDDF9521D2F679686C9E"];
  };

  services.syncthing.enable = true;
  services.syncthing.tray.enable = false;

  home.stateVersion = "24.05";
}
