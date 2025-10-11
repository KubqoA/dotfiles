{lib, ...}: {
  imports = lib.imports [
    "hm/aliases"
    "hm/fish"
    "hm/git"
    "hm/home"
    "hm/neovim"
    "hm/password-store"
  ];

  home.file.".hushlogin".text = "";

  programs = {
    bat.enable = true;
    fish.art = null;
    zoxide.enable = true;
  };

  home.stateVersion = "24.11";
}
