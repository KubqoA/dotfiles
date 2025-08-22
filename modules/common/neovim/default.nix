# [home-manager]
# inspired by https://nixalted.com/
{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."nvim/lua".source = ./lua;

  home.sessionVariables = rec {
    EDITOR = "nvim";
    GIT_EDITOR = EDITOR;
  };

  # Editor
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withRuby = false; # use Ruby from mise, not the built-in one

    # Add missing formatters, and language server packages
    # Most of these are managed in `modules/dev` for the respective languages
    extraPackages = with pkgs; [
      # formatters
      alejandra
      stylua

      # Telescope
      ripgrep

      # language servers
      lua-language-server
      nil
      nixd
      harper
    ];

    plugins = let
      kanso-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "kanso.nvim";
        version = "2025-06-03";
        src = pkgs.fetchFromGitHub {
          owner = "webhooked";
          repo = "kanso.nvim";
          rev = "d5975aa93bc157cfc60d4863d0704ab1d6e4deca";
          hash = "sha256-ktCd9KUxrZI0BYuYvadWwRCST3A7U3KOFpCBNCtSyp0=";
        };
        meta.homepage = "https://github.com/webhooked/kanso.nvim";
        meta.hydraPlatforms = [];
      };
    in
      with pkgs.vimPlugins; [
        lazy-nvim # plugin manager

        # LSP related
        blink-cmp # completion
        friendly-snippets
        lazydev-nvim # better luals support for neovim config
        nvim-lspconfig
        conform-nvim # formatter
        trouble-nvim # pretty diagnostics

        # UI
        kanso-nvim # theme
        nvim-web-devicons # nerd font icons
        vim-vinegar # better netrw
        gitsigns-nvim
        incline-nvim # floating filename
        dropbar-nvim # IDE-like breadcrumbs
        lualine-nvim # better statusline
        noice-nvim # replaces UI for cmdline, messages, ...
        nui-nvim

        (nvim-treesitter.withPlugins
          (plugins:
            with plugins; [
              tree-sitter-bash
              tree-sitter-c
              tree-sitter-clojure
              tree-sitter-fennel
              tree-sitter-haskell
              tree-sitter-json
              tree-sitter-lua
              tree-sitter-markdown
              tree-sitter-markdown_inline
              tree-sitter-nix
              tree-sitter-python
              tree-sitter-query
              tree-sitter-ruby
              tree-sitter-rust
              tree-sitter-typescript
              tree-sitter-vim
              tree-sitter-vimdoc
              tree-sitter-yaml
            ]))
      ];

    extraLuaConfig = ''
      vim.loader.enable()
      vim.g.mapleader = " " -- Need to set leader before lazy for correct keybindings
      require("lazy").setup({
        spec = {
          -- Import plugins from lua/plugins
          { import = "plugins" },
        },
        performance = {
          reset_packpath = false,
          rtp = {
            reset = false,
          },
        },
        dev = {
          path = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
          patterns = {""}, -- Empty string = wildcard, all plugins will use dev dir
        },
        install = {
          -- Safeguard in case we forget to install a plugin with Nix
          missing = false,
        },
      })

      require("config.opt")
      require("config.keymap")
    '';
  };
}
