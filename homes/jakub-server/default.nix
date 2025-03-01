{lib, ...}: {
  imports = lib.imports [
    "common/aliases"
    "common/env"
    "common/git"
    "common/home"
    "common/neovim"
    "common/password-store"
    "common/zsh"
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
