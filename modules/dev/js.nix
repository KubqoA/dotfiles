{...}: {
  imports = [./mise.nix];

  home.sessionVariables = {
    MISE_NODE_COREPACK = "true";
  };

  # pin versions for better reproducibility
  programs.mise.globalConfig = {
    # env._.path = ["{{config_root}}/node_modules/.bin"];
    tools = {
      bun = "1.2.15";
      deno = "2.3.5";
      node = "23.11.1";
      "npm:@anthropic-ai/claude-code" = "1.0.6";
      "npm:@astrojs/language-server" = "2.15.4";
      "npm:@biomejs/biome" = "1.9.4";
      "npm:@tailwindcss/language-server" = "0.14.20";
      "npm:stimulus-language-server" = "1.0.4";
      "npm:turbo-language-server" = "0.0.2";
      "npm:typescript-language-server" = "4.3.4";
    };
    settings.npm.bun = true;
  };
}
