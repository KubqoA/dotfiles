{
  lib,
  pkgs,
  ...
}: {
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
    extraLuaConfig = lib.readFile ./init.lua;
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
      #hyprland-vim-syntax = pkgs.vimUtils.buildVimPlugin {
      #  name = "hyprland-vim-syntax";
      #  src = pkgs.fetchFromGitHub {
      #    owner = "theRealCarneiro";
      #    repo = "hyprland-vim-syntax";
      #    rev = "71760fe0cad972070657b0528f48456f7e0027b2";
      #    sha256 = "08lpa1q4m52xnhd9a017q6xnl5pagjsvdfiv0z5gsv55msz86mw6";
      #  };
      #};
    in
      with pkgs.vimPlugins; [
        rose-pine # theme
        vim-vinegar # better netrw
        comment-nvim # easier commenting
        autoclose-nvim # auto pairs & closes brackets
        # copilot-vim
        conform-nvim # formatter setup
        gitsigns-nvim
        direnv-vim # better direnv integration

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
            tree-sitter-rust
            tree-sitter-typescript
            tree-sitter-yaml
          ]))

        nvim-lspconfig
      ];
  };
}
