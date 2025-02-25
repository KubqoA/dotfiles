# [home-manager]
{
  config,
  lib,
  ...
}: let
  inherit (config.xdg) configHome;
in {
  home.sessionVariables = {
    MISE_NODE_COREPACK = "true";
    MISE_NODE_DEFAULT_PACKAGES_FILE = "${configHome}/mise/default-npm-packages";
  };

  xdg.configFile = {
    "mise/default-npm-packages".text = ''
      stimulus-language-server
      typescript-language-server
      typescript
      yarn
      pnpm
    '';
  };

  programs.git.ignores = ["mise.local.toml"];

  programs.mise = {
    enable = true;
    # On macOS manage mise by homebrew - more frequent updates
    package = lib._.brew-alias "mise";
    globalConfig = {
      tools = {
        bun = "latest";
        deno = "latest";
        node = "latest";
        python = "latest";
        rust = "latest";
      };
      settings = {
        rust = lib.mkIf config.xdg.enable {
          cargo_home = config.home.sessionVariables.CARGO_HOME;
          rustup_home = config.home.sessionVariables.RUSTUP_HOME;
        };
      };
    };
  };
}
