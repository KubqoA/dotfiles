{lib, ...}: {
  imports = lib.imports [
    "common/aliases"
    "common/fish"
    "common/git"
    "common/home"
    "common/neovim"
    "common/password-store"
  ];

  home.file.".hushlogin".text = "";

  programs = {
    bat.enable = true;
    fish.art = null;
    zoxide.enable = true;
  };

  home.stateVersion = "24.11";
}
