# [home-manager]
{...}: {
  xdg.enable = true;

  home.sessionVariables = {
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    BUNDLE_USER_CACHE = "$XDG_CACHE_HOME/bundle";
    BUNDLE_USER_CONFIG = "$XDG_CONFIG_HOME/bundle/config";
    BUNDLE_USER_PLUGIN = "$XDG_DATA_HOME/bundle";
    MAVEN_OPTS = ''-Dmaven.repo.local="$XDG_DATA_HOME"/maven/repository'';
    NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
    SOLARGRAPH_CACHE = "$XDG_CACHE_HOME/solargraph";
    REDISCLI_HISTFILE = "$XDG_DATA_HOME/redis/rediscli_history";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    SQLITE_HISTORY = "$XDG_DATA_HOME/sqlite_history";
    TERMINFO = "$XDG_DATA_HOME/terminfo";
    TERMINFO_DIRS = "$XDG_DATA_HOME/terminfo:/usr/share/terminfo";
  };

  home.shellAliases = {
    wget = ''wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'';
    yarn = ''yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'';
  };
}
