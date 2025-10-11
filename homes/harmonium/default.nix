{lib, ...}: {
  imports = lib.imports [
    "hm/aliases"
    "hm/fish"
    "hm/ghostty"
    "hm/git"
    "hm/gpg"
    "hm/home"
    "hm/neovim"
    "hm/password-store"
    "hm/ssh"
    "hm/xdg"
    ./desktop
    ./programs.nix
  ];

  home.stateVersion = "24.05";
}
