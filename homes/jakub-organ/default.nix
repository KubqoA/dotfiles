{lib, ...}: {
  imports = lib.imports [
    "common/aliases"
    "common/fish"
    "common/git"
    "common/home"
    "common/neovim"
    "common/password-store"
  ];

  programs = {
    bat.enable = true;
    zoxide.enable = true;
  };

  home.stateVersion = "24.11";
}
