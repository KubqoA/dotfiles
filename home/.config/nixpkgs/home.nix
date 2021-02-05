{ config, pkgs, ... }:

let
  homeDirectory = "/home/jarbet";
  firefox-theme = pkgs.fetchFromGitHub {
    owner = "fellowish";
    repo = "firefox-review";
    rev = "v1.1.3";
    sha256 = "1z31ffxxj8s1z6x46xrwrgy446x0b758v3pyy15aq7fiyvrhf35d";
  };
in
{
  imports = [
    ./modules/dev.nix
    ./modules/media.nix
    ./modules/ssh.nix
    ./modules/utils.nix
    ./modules/waybar.nix
    ./modules/wm.nix
    ./modules/zsh.nix
  ];

  xdg.enable = true;
  xdg.configHome = "${homeDirectory}/.config";
  xdg.dataHome = "${homeDirectory}/.local/share";
  xdg.cacheHome = "${homeDirectory}/.cache";
  xdg.userDirs = {
    desktop = "\$HOME";
    documents = "\$HOME";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles.unacorda = {
      path = "unacorda";
      userChrome = builtins.readFile "${firefox-theme}/userChrome.css";
      userContent = builtins.readFile "${firefox-theme}/userContent.css";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "media.rdd-vpx.enabled" = false;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };
    };
  };
  home.file.".mozilla/firefox/${config.programs.firefox.profiles.unacorda.path}/chrome/userColors.css".source = "${firefox-theme}/userColors.css";

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jarbet";
  home.homeDirectory = homeDirectory;
  home.language.base = "en_US.UTF-8";

  home.stateVersion = "20.09";
}
