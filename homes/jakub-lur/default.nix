{
  config,
  lib,
  ...
}: {
  imports = lib.imports [
    "common/aliases"
    "common/env"
    "common/fish"
    "common/git"
    "common/home"
    "common/neovim"
    "common/password-store"
    "common/xdg"
  ];

  programs = {
    bat.enable = true;
    gpg.enable = true;
    zoxide.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableFishIntegration = true;
    defaultCacheTtl = 172800;
    maxCacheTtl = 172800;
    defaultCacheTtlSsh = 172800;
    maxCacheTtlSsh = 172800;
    sshKeys = [config.gpgSshControl];
    # Custom pinentry program taken from https://github.com/rupor-github/win-gpg-agent
    # TODO: Possibly turn into a nix package
    extraConfig = ''
      pinentry-program /home/jakub/pinentry.exe
    '';
  };

  home.stateVersion = "24.11";
}
