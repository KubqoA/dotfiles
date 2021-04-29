{ config, lib, pkgs, ... }:

let
  otf-apple = pkgs.callPackage ./src/otf-apple {};
in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    <nixos-hardware/lenovo/thinkpad/t440s>
    ./hardware-configuration.nix
    ./cachix.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

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

  # Networking
  networking.hostName = "unacorda";
  networking.networkmanager = {
    enable = true;
    insertNameservers = [ "1.1.1.1" "1.0.0.1" ];
  };
  
  time.timeZone = "Europe/Bratislava";

  # Users
  users.defaultUserShell = pkgs.zsh;
  users.extraUsers.jarbet = {
    hashedPassword = import ./password.nix;
    isNormalUser = true; 
    extraGroups = [ "audio" "video" "networkmanager" "storage" ];
  };
  security.doas.enable = true;
  security.doas.extraRules = [ { users = [ "jarbet" ]; noPass = true; keepEnv = true; } ];
  services.mingetty.autologinUser = "jarbet";

  # Fix gdk-pixbuf .svg bug
  environment.sessionVariables = {
    GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
  };

  environment.systemPackages = with pkgs; with pkgs.python38Packages; [
    # utils
    bat fzy efibootmgr tpacpi-bat libappindicator
    networkmanager_openvpn
    # audio
    pulseaudio-ctl playerctl pavucontrol
    # apps
    brave
    # nonfree
    slack teams zoom-us

    # dev
    shellcheck
    # jvm
    jre jdk11 kotlin
    # - clojure
    clojure leiningen clj-kondo clojure-lsp
    # node
    nodePackages.pnpm yarn nodejs-14_x
    # go
    go gopls
    # haskell
    ghc haskellPackages.haskell-language-server cabal2nix cabal-install hlint
    hlint haskellPackages.HUnit haskellPackages.QuickCheck haskellPackages.hpp
    haskellPackages.parsec_3_1_14_0
    # python
    python3 pytest mypy flake8
    # c
    gcc gdb cmake valgrind cppcheck llvm clang clang-tools
    autoconf automake binutils gnumake
    # others
    swiProlog

    # wayland/sway related packages
    swaylock-effects swayidle swaybg autotiling slurp grim
    wl-clipboard wf-recorder xdg-desktop-portal-wlr
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
  programs.sway = {
    enable = true;
    # remove dmenu and rxvt-unicode from extraPackages
    extraPackages = with pkgs; [ swaylock-effects swayidle xwayland alacritty ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  services.postgresql = {
    enable = true;
    authentication = lib.mkForce ''
      local all all              trust
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128      trust
    '';
    ensureDatabases = import ./databases.nix;
  };
  services.printing.enable = true;
  services.tlp.enable = true;
  services.udisks2.enable = true;
  services.fprintd.enable = true;
  services.onedrive.enable = true;

  system.stateVersion = "20.09";
}

