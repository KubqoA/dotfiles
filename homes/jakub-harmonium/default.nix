{
  lib,
  pkgs,
  ...
}: {
  imports = lib.imports [
    "common/aliases"
    "common/fish"
    "common/ghostty"
    "common/git"
    "common/gpg"
    "common/home"
    "common/neovim"
    "common/password-store"
    "common/ssh"
    "common/xdg"
    ./desktop
  ];

  programs = {
    bat.enable = true;
    zoxide.enable = true;
  };

  home.packages = with pkgs; [
    chromium
    firefox
    obsidian
  ];

  services.syncthing.enable = true;

  home.stateVersion = "24.05";
}
