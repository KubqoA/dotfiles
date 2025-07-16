{
  config,
  lib,
  ...
}: {
  imports = lib.imports [
    "common/aliases"
    "common/fish"
    "common/git"
    "common/gpg"
    "common/home"
    "common/neovim"
    "common/password-store"
    "common/ssh"
    "common/xdg"
    "dev/js"
    "dev/php"
    "dev/python"
    "dev/ruby"
    "dev/rust"
  ];

  programs = {
    bat.enable = true;
    zoxide.enable = true;
  };

  # Custom pinentry program taken from https://github.com/rupor-github/win-gpg-agent
  # TODO: Possibly turn into a nix package
  services.gpg-agent.extraConfig = ''
    pinentry-program /home/jakub/pinentry.exe
  '';

  home.stateVersion = "24.11";
}
