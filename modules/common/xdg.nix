# [home-manager]
{config, ...}: let
  inherit (config.xdg) dataHome configHome cacheHome stateHome;
in {
  xdg = {
    enable = true;
    configFile = {
      "npm/npmrc".text = ''
        prefix=''${XDG_DATA_HOME}/npm
        cache=''${XDG_CACHE_HOME}/npm
        init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
        logs-dir=''${XDG_STATE_HOME}/npm/logs
      '';
    };
  };

  home.sessionVariables = {
    CARGO_HOME = "${dataHome}/cargo";
    DOCKER_CONFIG = "${configHome}/docker";
    IRBRC = "${configHome}/irb/irbrc";
    MAVEN_OPTS = "-Dmaven.repo.local=${dataHome}/maven/repository";
    NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
    NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
    PSQL_HISTORY = "${stateHome}/psql_history";
    PYTHON_HISTORY = "${dataHome}/python_history";
    SOLARGRAPH_CACHE = "${cacheHome}/solargraph";
    REDISCLI_HISTFILE = "${dataHome}/rediscli_history";
    RUSTUP_HOME = "${dataHome}/rustup";
    SQLITE_HISTORY = "${dataHome}/sqlite_history";
    TERMINFO = "${dataHome}/terminfo";
    TERMINFO_DIRS = "${dataHome}/terminfo:/usr/share/terminfo";
  };

  home.shellAliases = {
    wget = ''wget --hsts-file="${dataHome}/wget-hsts"'';
    yarn = ''yarn --use-yarnrc "${configHome}/yarn/config"'';
  };

  nix.settings.use-xdg-base-directories = true;
}
