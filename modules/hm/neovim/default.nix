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
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withPython3 = false;
    withRuby = false; # use Ruby from mise, not the built-in one

    # Add formatters, and language server packages
    # Most of these are managed in `modules/dev` for the respective languages
    extraPackages = with pkgs; [
      # formatters
      alejandra # nix
      stylua # Lua

      # language servers
      harper # grammar checker
      lua-language-server
      marksman # Markdown
      nil # nix
      vscode-json-languageserver
      yaml-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim # plugin manager

      # LSP related
      blink-cmp # completion
      friendly-snippets
      lazydev-nvim # better luals support for neovim config
      nvim-lspconfig
      conform-nvim # formatter
      trouble-nvim # pretty diagnostics

      # Treesitter
      nvim-treesitter.withAllGrammars
      nvim-ts-autotag

      # UI
      kanso-nvim # theme
      nvim-web-devicons # nerd font icons
      vim-vinegar # better netrw
      gitsigns-nvim
      dropbar-nvim # IDE-like breadcrumbs
      lualine-nvim # better statusline
      noice-nvim # replaces UI for cmdline, messages, ...
      nui-nvim
    ];

    initLua = ''
      vim.loader.enable() -- Enables built-in module loader cache system

      require("config") -- first setup general settings

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

      require("keymap")
    '';
  };
}
