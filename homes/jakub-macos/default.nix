{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.imports [
    "common/aliases"
    "common/env"
    "common/ghostty"
    "common/git"
    "common/home"
    "common/mise"
    "common/neovim"
    "common/password-store"
    "common/xdg"
    "common/zsh"
    "darwin/dark-mode-notify"
    "dev/php"
    "dev/ruby"
    "dev/work"
  ];

  home = {
    packages = with pkgs; [
      hyperfine
      git-crypt
      nerdfetch
      oath-toolkit # fix pass support in Raycast
      tldr
      bat
      httpie
      pinentry_mac

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
      ".gnupg/sshcontrol".text = "${config.gpgSshControl}\n";
      ".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 172800
        max-cache-ttl 172800
        default-cache-ttl-ssh 172800
        max-cache-ttl-ssh 172800
        pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
      '';
    };
  };

  programs = {
    gpg.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh.initExtraBeforeCompInit = ''
      # Inlined from ‹eval "$(/opt/homebrew/bin/brew shellenv)"›
      fpath+="/opt/homebrew/share/zsh/site-functions"

      # Inlined from ‹~/.orbstack/shell/init.zsh›
      fpath+="/Applications/OrbStack.app/Contents/MacOS/../Resources/completions/zsh"
    '';
  };

  home.stateVersion = "24.05";
}
