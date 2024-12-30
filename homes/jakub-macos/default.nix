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
    "common/home"
    "common/neovim"
    "common/password-store"
    "common/xdg"
    "common/zsh"
    "darwin/dark-mode-notify"
  ];

  home = {
    packages = with pkgs; let
      phpEnv = php84.buildEnv {
        extensions = {
          enabled,
          all,
        }:
          enabled ++ (with all; [ctype curl dom fileinfo mbstring openssl pdo session tokenizer]);
      };
    in [
      hyperfine
      git-crypt
      pinentry_mac
      nerdfetch
      oath-toolkit # fix pass support in Raycast

      # dev env managed by mise, but here are some exceptions
      phpEnv
      phpEnv.packages.composer
      shellcheck
    ];

    sessionVariables = {
      # Ruby
      OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
      DISABLE_SPRING = "true";
      RUBY_YJIT_ENABLE = 1;
      RUBY_CONFIGURE_OPTS = "--enable-yjit --with-jemalloc";

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

      # Work
      IAC_PATH = "$HOME/Documents/betterstack/infrastructure-as-code";
    };

    shellAliases = {
      # Work
      linear = "git checkout main && git pull && git checkout -b $(pbpaste)";
      swarm = "mise x ruby@$(cat $IAC_PATH/.ruby-version) -- $IAC_PATH/exe/swarm";
      prod-deploy = "git checkout main && git pull && swarm production deploy";
      staging-deploy = "git checkout main && git pull && swarm staging deploy";
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
    mise = {
      enable = true;
      globalConfig.tools = {
        bun = "latest";
        deno = "latest";
        node = ["latest" "20.3.0"];
        python = "latest";
        ruby = ["latest" "3.3.4" "3.1.1"];
        rust = "latest";
      };
    };
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
