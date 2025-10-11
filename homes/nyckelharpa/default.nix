{
  lib,
  pkgs,
  ...
}: {
  imports = lib.imports [
    "hm/aliases"
    "hm/dark-mode-notify"
    "hm/fish"
    "hm/ghostty"
    "hm/git"
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

  home = {
    packages = with pkgs; [
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
    bat = {
      enable = true;
      config.theme = "base16";
    };
    fzf.enable = true;
    gpg.enable = true;
    zoxide.enable = true;
  };

  home.stateVersion = "24.05";
}
