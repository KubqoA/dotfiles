{ config, lib, pkgs, ... }:

with lib;
{
  config.programs.neovim = {
    enable = true;
    vimAlias = true;
    configure = {
      customRC = ''
lua <<EOF
${readFile ./neovim.lua}
EOF
'';
      packages.myPlugins = let
        vim-bind = pkgs.vimUtils.buildVimPlugin {
          name = "vim-bind";
          src = pkgs.fetchFromGitHub {
            owner = "Absolight";
            repo = "vim-bind";
            rev = "4967dc658b50d71568f9f80fce2d27e6a4698fc5";
            sha256 = "0hif1r329i5mylgkcb24dl1xcn287fvy7hpfln3whv8bwmphfc77";
          };
        };
      in with pkgs.vimPlugins; {
        start = [
	        impatient-nvim # speeds up loading Lua modules
          vim-vinegar # better netrw
          vim-commentary # easier commenting
	        onenord-nvim # theme
	        vim-bind # better bind zone higlighting

          (nvim-treesitter.withPlugins (plugins: with plugins; [
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
            tree-sitter-typescript
            tree-sitter-yaml
          ]))
	        
          nvim-lspconfig
        ];
      };
    };
  };
}
