{lib, ...}: {
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
    ./programs.nix
  ];

  home.stateVersion = "24.05";
}
