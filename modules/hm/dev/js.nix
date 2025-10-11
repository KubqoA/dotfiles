{
  config,
  lib,
  ...
}: let
  xdgOptional = lib.mkIf config.xdg.enable;
in {
  imports = [./mise.nix];

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
    # env._.path = ["{{config_root}}/node_modules/.bin"];
    # pin versions for better reproducibility
    tools = {
      bun = "1.3";
      deno = "2.5";
      node = "24";
      "npm:@astrojs/language-server" = "2.15.4";
      "npm:@tailwindcss/language-server" = "0.14.28";
      "npm:stimulus-language-server" = "1.0.4";
      "npm:turbo-language-server" = "0.0.2";
      "npm:typescript-language-server" = "5.0.1";
    };
    settings = {
      idiomatic_version_file_enable_tools = ["node"];
      node.compile = false;
      npm.bun = true;
    };
  };
}
