{ config, pkgs, ... }:

let
  athens = pkgs.callPackage ../pkgs/athens {};
  firefox-theme = pkgs.fetchFromGitHub {
    owner = "fellowish";
    repo = "firefox-review";
    rev = "v1.1.3";
    sha256 = "1z31ffxxj8s1z6x46xrwrgy446x0b758v3pyy15aq7fiyvrhf35d";
  };
in
{
  home.packages = with pkgs; [
    athens signal-desktop
  ];

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
}