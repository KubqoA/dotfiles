{
  lib,
  pkgs,
  ...
}: {
  imports = lib.imports [
    "hm/base"
    "hm/ghostty"
    "hm/gpg"
    "hm/password-store"
    "hm/ssh"
    ./desktop
  ];

  programs = {
    eza.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
  };

  services = {
    syncthing.enable = true;
  };

  home.packages = with pkgs; [
    chromium
    firefox
    obsidian
  ];
}
