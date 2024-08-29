{pkgs, ...}: {
  home.packages = with pkgs; [
    # formatters
    stylua
    isort
    black

    # language servers - move to direnv per project
    nixd
    lua-language-server
  ];

  # Editor
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraLuaConfig = builtins.readFile ./init.lua;
    plugins = let
      vim-bind = pkgs.vimUtils.buildVimPlugin {
        name = "vim-bind";
        src = pkgs.fetchFromGitHub {
          owner = "Absolight";
          repo = "vim-bind";
          rev = "4967dc658b50d71568f9f80fce2d27e6a4698fc5";
          sha256 = "0hif1r329i5mylgkcb24dl1xcn287fvy7hpfln3whv8bwmphfc77";
        };
      };
      auto-dark-mode-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "auto-dark-mode.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "f-person";
          repo = "auto-dark-mode.nvim";
          rev = "14cad96b80a07e9e92a0dcbe235092ed14113fb2";
          hash = "sha256-bSkS2IDkRMQCjaePFYtq39Bokgd1Bwoxgu2ceP7Bh5s=";
        };
      };
    in
      with pkgs.vimPlugins; [
        rose-pine # theme
        auto-dark-mode-nvim
        vim-vinegar # better netrw
        autoclose-nvim # auto pairs & closes brackets
        # copilot-vim
        conform-nvim # formatter setup
        gitsigns-nvim
        direnv-vim # better direnv integration
        plenary-nvim

        cmp-nvim-lsp
        cmp-buffer
        cmp-cmdline
        cmp-path
        luasnip
        nvim-snippy
        cmp-snippy
        nvim-cmp

        vim-bind # better bind zone higlighting
        (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-clojure
            tree-sitter-fennel
            tree-sitter-haskell
            tree-sitter-json
            tree-sitter-lua
            tree-sitter-markdown
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-ruby
            tree-sitter-rust
            tree-sitter-typescript
            tree-sitter-yaml
          ]))

        nvim-lspconfig
      ];
  };
}
