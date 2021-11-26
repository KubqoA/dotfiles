{ config, inputs, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.neovim;
  inherit (config.dotfiles) configDir;
in {
  options.modules.shell.neovim = {
    enable = _.mkBoolOpt false;
    lsp = {
      servers = mkOption {
        type = types.listOf types.str;
        description = "List of lanugage servers to support in LSP"; 
        default = [];
        example = [
          # Supported language servers
          "clangd"
          "clojure_lsp"
          "gopls"
          "hls"
          # "html" TODO: add package (node: https://github.com/hrsh7th/vscode-langservers-extracted)
          # "json" TODO: add package (node: https://github.com/hrsh7th/vscode-langservers-extracted)
          "pyright"
          "rnix"
          # "sqls" TODO: add package (go: https://github.com/lighttiger2505/sqls)
          # "tailwindcss" TODO: add package (node: https://github.com/tailwindlabs/tailwindcss-intellisense)
          "tsserver"
        ];
      };
    };
  };

  config = let
    lspServerPkgs = with pkgs; {
      clangd = clang-tools;
      clojure_lsp = clojure-lsp;
      gopls = gopls;
      hls = unstable.haskell-language-server;
      pyright = nodePackages.pyright;
      rnix = rnix-lsp;
      tsserver = nodePackages.typescript-language-server;
    };
    enabledLspServers = map (lspServer: lspServerPkgs."${lspServer}") cfg.lsp.servers;
  in mkIf cfg.enable {
    # nixpkgs.overlays = [ inputs.neovim-nightly.overlay ];

    # nix.binaryCaches = [ "https://nix-community.cachix.org/" ];
    # nix.binaryCachePublicKeys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

    user.packages = with pkgs; [
      unstable.neovim
      parinfer-rust
    ] ++ enabledLspServers;
  };
}
