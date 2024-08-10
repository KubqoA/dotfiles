{pkgs, ...}: {
  home = {
    username = "jakub";
    homeDirectory = "/Users/jakub";

    packages = with pkgs; [
      home-manager
      hyperfine
      curl
      wget
      git-crypt
      pinentry_mac
    ];

    sessionVariables = rec {
      EDITOR = "nvim";
      GIT_EDITOR = EDITOR;

      # Work
      OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
      DISABLE_SPRING = "true";
      IAC_PATH = "$HOME/Documents/betterstack/infrastructure-as-code";
    };

    shellAliases = {
      cd = "z";
      ls = "ls --color=tty";
      chx = "chmod +x";
      hm = "home-manager --flake \"$HOME/.config/dotfiles#jakub-macos\"";
      mkdarwin = "darwin-rebuild switch --flake ~/.config/dotfiles";
      dots = "$EDITOR ~/.config/dotfiles";

      # Git
      gc = "git commit";
      gca = "git commit --amend";
      gcan = "git commit --amend --no-edit";
      gp = "git pull";
      gpu = "git push";
      gpf = "git push --force";
      grm = "git pull origin main --rebase";
      grc = "git rebase --continue";
      gra = "git rebase --abort";

      # Utils
      benchzsh = "hyperfine 'zsh -i -c exit' --warmup 1";

      # Work
      swarm = "RBENV_VERSION=$(cat $IAC_PATH/.ruby-version) $IAC_PATH/exe/swarm";
    };

    file = {
      # Disable the Last login message in the terminal
      ".hushlogin".text = "";
      ".config/zsh/art".source = ./art;
      # Set up gpg agent configuration
      ".gnupg/sshcontrol".text = "CC54AAD6EF69F323DEB5CDDF9521D2F679686C9E";
      ".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 172800
        max-cache-ttl 172800
        default-cache-ttl-ssh 172800
        max-cache-ttl-ssh 172800
        pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
      '';
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Jakub Arbet";
    userEmail = "hi@jakubarbet.me";
    signing = {
      key = "4EB39A80B52672EC";
      signByDefault = true;
    };
    ignores = [
      ".DS_Store"
      ".idea"
    ];
  };

  programs.gpg.enable = true;

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings.PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "emacs";
    history = {
      path = "$HOME/.local/share/.zsh_history";
      size = 10000;
      save = 10000;
    };
    completionInit = ''
      # Autoload compinit with caching for 24h
      setopt extendedglob
      autoload -Uz compinit
      if [[ ! -f $ZDOTDIR/.zcompdump || -n $ZDOTDIR/.zcompdump(#qNmh+24) ]]; then
        compinit
        touch $ZDOTDIR/.zcompdump
        zcompile $ZDOTDIR/.zcompdump
      else
        compinit -C;
      fi
    '';
    profileExtra = builtins.readFile ./profile;
    envExtra = builtins.readFile ./zshenv;
    loginExtra = builtins.readFile ./zlogin;
    initExtra = builtins.readFile ./zshrc;

    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    plugins = [
      {
        name = "pure";
        src = "${pkgs.pure-prompt}/share/zsh/site-functions";
      }
      {
        name = "zsh-completions";
        src = "${pkgs.zsh-completions}/share/zsh/site-functions";
      }
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
    ];
  };

  home.stateVersion = "24.05";
}
