{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.zsh;
  inherit (config.dotfiles) configDir;
in {
  options.modules.shell.zsh = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ nix-zsh-completions ];
    user.shell = pkgs.zsh;
    home.configFile."art".source = "${configDir}/art";
    home._.programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      shellAliases = import "${configDir}/zsh/aliases.nix";
      defaultKeymap = "viins";
      autocd = true;
      dotDir = ".config/zsh";
      history = {
        path = "$XDG_DATA_HOME/zsh/zsh_history";
        save = 50000;
        size = 50000;
      };
      sessionVariables = rec {
        KEYTIMEOUT = 1;
        EDITOR = "vim";
        VISUAL = EDITOR;
        GIT_EDITOR = EDITOR;
        BROWSER = "firefox";
        PAGER = "less";
        PATH = "$PATH:$HOME/.local/bin:$HOME/.config/composer/vendor/bin";
      };
      initExtraBeforeCompInit = ''
        ${builtins.readFile "${configDir}/zsh/pre-compinit.zsh"}
      '';
      initExtra = builtins.readFile "${configDir}/zsh/post-compinit.zsh";
      plugins = [
        rec {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = name;
            rev = "0.8.0-alpha1-pre-redrawhook";
            sha256 = "1gv7cl4kyqyjgyn3i6dx9jr5qsvr7dx1vckwv5xg97h81hg884rn";
          };
        }
        rec {
          name = "zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = name;
            rev = "0.32.0";
            sha256 = "12l9wrx0aysyj62kgp5limglz0nq73w8c415wcshxnxmhyk6sw6d";
          };
        }
        rec {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = name;
            rev = "v1.0.2";
            sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
          };
        }
      ];
    };
  };
}
