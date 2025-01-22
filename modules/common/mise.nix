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
    "mise/default-gems".text = ''
      rails
    '';
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
    globalConfig = {
      tools = {
        bun = "latest";
        deno = "latest";
        node = ["latest" "20.3.0"];
        python = "latest";
        ruby = ["latest" "3.3.4" "3.1.1"];
        rust = "latest";
      };
      settings = {
        ruby.default_packages_file = "${configHome}/mise/default-gems";
        rust = lib.mkIf config.xdg.enable {
          cargo_home = config.home.sessionVariables.CARGO_HOME;
          rustup_home = config.home.sessionVariables.RUSTUP_HOME;
        };
      };
    };
  };
}
