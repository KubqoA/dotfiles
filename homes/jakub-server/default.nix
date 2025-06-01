{lib, ...}: {
  imports = lib.imports [
    "common/aliases"
    "common/env"
    "common/fish"
    "common/git"
    "common/home"
    "common/neovim"
    "common/password-store"
  ];

  programs = {
    bat.enable = true;
    git.signing.signByDefault = false;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  home.stateVersion = "24.11";
}
