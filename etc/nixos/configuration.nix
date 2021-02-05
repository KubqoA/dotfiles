{ config, lib, pkgs, ... }:

let
  otf-apple = pkgs.callPackage ./src/otf-apple {};
in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    <nixos-hardware/lenovo/thinkpad/t440s>
    ./hardware-configuration.nix
  ];

  # Video and audio configuration
  hardware.enableAllFirmware = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      vaapiIntel
    ];
  };
  hardware.bluetooth = {
    enable = true;
    config = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    extraConfig = "load-module module-switch-on-connect";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  # Networking
  networking.hostName = "unacorda";
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.wireless.enable = true;
  networking.wireless.networks = import ./wireless.nix;
  
  time.timeZone = "Europe/Bratislava";

  # Users
  users.defaultUserShell = pkgs.zsh;
  users.extraUsers.jarbet = {
    hashedPassword = import ./password.nix;
    isNormalUser = true; 
    extraGroups = [ "audio" "video" ];
  };
  security.doas.enable = true;
  security.doas.extraRules = [ { users = [ "jarbet" ]; noPass = true; keepEnv = true; } ];

  # Fix gdk-pixbuf .svg bug
  environment.sessionVariables = {
    GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
  };

  environment.systemPackages = with pkgs; [
    # utils
    bat fzy efibootmgr
    # audio
    pulseaudio-ctl playerctl pavucontrol
    # term
    alacritty
    # browser
    ungoogled-chromium
    # nonfree
    slack teams zoom-us spotify
    # dev
    neovim 
    clojure leiningen kotlin
    nodePackages.pnpm yarn nodejs
    shellcheck
    # wayland/sway related packages
    swaylock-effects swayidle swaybg autotiling slurp grim
    wl-clipboard wf-recorder xdg-desktop-portal-wlr pipewire
    nwg-launchers
    # visual
    capitaine-cursors gtk-engine-murrine
  ];

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [ font-awesome twitter-color-emoji otf-apple ];
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      emoji = [ "Font Awesome 5 Free" "Noto Color Emoji" ];
      monospace = [ "SF Mono" ];
      serif = [ "New York Medium" ];
      sansSerif = [ "SF Pro Text" ];
    };
  };

  programs.light.enable = true;
  programs.sway.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.printing.enable = true;

  services.postgresql = {
    enable = true;
    authentication = lib.mkForce ''
      local all all              trust
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128      trust
    '';
    ensureDatabases = import ./databases.nix;
  };

  system.stateVersion = "20.09";
}

