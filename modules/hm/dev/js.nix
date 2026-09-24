{
  config,
  lib,
  ...
}: let
  xdgOptional = lib.mkIf config.xdg.enable;
in {
  imports = [./mise.nix];

  # Globally installed npm packages, the prefix is moved by npmrc below
  home.sessionPath = xdgOptional ["${config.xdg.dataHome}/npm/bin"];

  home.shellAliases.yarn = xdgOptional ''yarn --use-yarnrc "${config.xdg.configHome}/yarn/config"'';

  # Yarn fails when the config passed with --use-yarnrc doesn't exist, it's kept writable for `yarn config set`
  home.activation.yarnConfig = xdgOptional (lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "${config.xdg.configHome}/yarn"
    run touch "${config.xdg.configHome}/yarn/config"
  '');

  home.sessionVariables = {
    MISE_NODE_COREPACK = "true";
    NODE_REPL_HISTORY = xdgOptional "${config.xdg.dataHome}/node_repl_history";
    NPM_CONFIG_USERCONFIG = xdgOptional "${config.xdg.configHome}/npm/npmrc";
  };

  xdg.configFile."npm/npmrc".text = xdgOptional ''
    prefix=''${XDG_DATA_HOME}/npm
    cache=''${XDG_CACHE_HOME}/npm
    init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
    logs-dir=''${XDG_STATE_HOME}/npm/logs
  '';

  programs.mise.globalConfig = {
    tools = {
      bun = "1.3";
      deno = "2.8";
      node = "24";
    };
    settings = {
      idiomatic_version_file_enable_tools = ["node"];
      node.compile = false;
      node.corepack = true;
    };
  };
}
