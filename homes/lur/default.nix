{
  config,
  lib,
  ...
}: {
  imports = lib.imports [
    "hm/aliases"
    "hm/fish"
    "hm/git"
    "hm/gpg"
    "hm/home"
    "hm/neovim"
    "hm/password-store"
    "hm/ssh"
    "hm/xdg"
    "hm/dev/js"
    "hm/dev/php"
    "hm/dev/python"
    "hm/dev/ruby"
    "hm/dev/rust"
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
