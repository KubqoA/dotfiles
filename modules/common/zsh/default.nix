# [home-manager]
# sensible defaults for zsh, including compiled config for faster startup
# platform/user specific config should go to `programs.zsh.profileExtra`
{pkgs, ...}: {
  home.file.".config/zsh/art".source = ./art;

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
}
