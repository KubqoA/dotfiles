{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.imports [
    "common/aliases"
    "common/fish"
    "common/ghostty"
    "common/git"
    "common/home"
    "common/neovim"
    "common/password-store"
    "common/ssh"
    "common/xdg"
    "darwin/dark-mode-notify"
    "dev/js"
    "dev/php"
    "dev/python"
    "dev/ruby"
    "dev/rust"
  ];

  home = {
    packages = with pkgs; [
      hyperfine
      git-crypt
      nerdfetch
      oath-toolkit # fix pass support in Raycast
      httpie

      # dev env managed by mise, but here are some exceptions
      shellcheck
    ];

    sessionVariables = {
      # Inlined from eval "$(/opt/homebrew/bin/brew shellenv)"
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info:''${INFOPATH:-}";

      # Include Homebrew and Orbstack in the PATH
      PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:$PATH:/Users/jakub/.orbstack/bin";

      # Fix Homebrew libs
      LDFLAGS = "-L/opt/homebrew/lib";
      CPPFLAGS = "-I/opt/homebrew/include";
    };

    file = {
      # Disable the Last login message in the terminal
      ".hushlogin".text = "";
      # Set up gpg agent configuration, home-manager gpg-agent module is not
      # supported on macOS
      ".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 172800
        max-cache-ttl 172800
        pinentry-program /opt/homebrew/bin/pinentry-mac
      '';
    };
  };

  programs = {
    # bat.enable = true;
    gpg.enable = true;
    zoxide.enable = true;
  };

  home.stateVersion = "24.05";
}
