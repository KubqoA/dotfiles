#                                      _
#  _   _ _ __   __ _  ___ ___  _ __ __| | __ _
# | | | | '_ \ / _` |/ __/ _ \| '__/ _` |/ _` |
# | |_| | | | | (_| | (_| (_) | | | (_| | (_| |
#  \__,_|_| |_|\__,_|\___\___/|_|  \__,_|\__,_|
#

{ inputs, lib, pkgs, ... }:

let
  inherit (lib._) enable;
in {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t440s
  ];

  #TODO temporary fixes
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [ font-awesome twitter-color-emoji _.otf-apple ];
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      emoji = [ "Font Awesome 5 Free" "Noto Color Emoji" ];
      monospace = [ "SF Mono" ];
      serif = [ "New York Medium" ];
      sansSerif = [ "SF Pro Text" ];
    };
  };
  services.getty.autologinUser = "jarbet";

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };
  # Fix an issue with a touchpad, where it would sometimes stop working
  # after suspend
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  time.timeZone = "Europe/Bratislava";

  environment.systemPackages = with pkgs; [ efibootmgr ];

  # Various packages that don't fit into any specific module
  user.packages = with pkgs; [
    # Dev
    httpie wrk heroku exercism jq _.tableplus _.vscode-insiders
    shellcheck

    # Communication
    slack zoom-us brave

    # Media
    imv transmission-gtk spotify

    # Utils
    ripgrep bat libappindicator pfetch unzip killall ncdu tree

    # Others
    _.athens
  ];

  modules = {
    shell = {
      git = enable;
      gpg = enable;
      neovim = enable;
      pass = enable;
      ssh = enable;
      zsh = enable;
    };
    desktop = {
      gtk.enable = true;
      games.enable = true;
      swaywm = {
        enable = true;
        term = "alacritty";
        wallpaper = ./assets/bg.jpg;
        lockWallpaper = ./assets/lock.jpg;
      };
      services = {
        wlsunset = enable;
      };
      apps = {
        chromium = enable;
        firefox = enable;
        mpv = enable;
        vscode = enable;
        zathura = enable;
      };
    };
    dev = {
      direnv = enable;

      c = enable;
      clojure = enable;
      ledger = enable;
      nix = enable;
    };
    hardware = {
      audio = {
        enable = true;
        pulseeffects.enable = false;
      };
      bluetooth = enable;
      graphics = {
        enable = true;
        vaapi.enable = true;
        vaapi.intelHybrid = true;
      };
    };
    services = {
      networkmanager = enable;
      postgresql = enable;
      onedrive = enable;
    };
  };

  # Various other services that don't live in modules
  services = {
    printing = enable;
    tlp = enable;
    udisks2 = enable;
    fprintd = enable;
  };
}
