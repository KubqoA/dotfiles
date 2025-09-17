{config, ...}: let
  inherit (config.xdg) dataHome configHome stateHome;
in {
  xdg.enable = true;

  home.sessionVariables = {
    DOCKER_CONFIG = "${configHome}/docker";
    MAVEN_OPTS = "-Dmaven.repo.local=${dataHome}/maven/repository";
    PSQL_HISTORY = "${stateHome}/psql_history";
    REDISCLI_HISTFILE = "${dataHome}/rediscli_history";
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
