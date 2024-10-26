{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib._.moduleImports [
    "common/aliases"
    "common/env"
    "common/git"
    "common/kitty"
    "common/neovim"
    "common/password-store"
    "common/zsh"
    "darwin/dark-mode-notify"
  ];

  home = {
    packages = with pkgs; [
      hyperfine
      git-crypt
      pinentry_mac
      bun
    ];

    sessionVariables = {
      # Work
      OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
      DISABLE_SPRING = "true";
      IAC_PATH = "$HOME/Documents/betterstack/infrastructure-as-code";
    };

    shellAliases = {
      # Work
      linear = "git checkout main && git pull && git checkout -b $(pbpaste)";
      swarm = "RBENV_VERSION=$(cat $IAC_PATH/.ruby-version) $IAC_PATH/exe/swarm";
      prod-deploy = "git checkout main && git pull && swarm production deploy";
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
    zsh.profileExtra = builtins.readFile ./profile;
  };

  home.stateVersion = "24.05";
}
