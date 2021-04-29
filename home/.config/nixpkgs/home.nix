{ config, pkgs, ... }:

let
  homeDirectory = "/home/jarbet";
in
{
  imports = [
    ./modules/apps.nix
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

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jarbet";
  home.homeDirectory = homeDirectory;
  home.language.base = "en_US.UTF-8";

  home.stateVersion = "20.09";
}
