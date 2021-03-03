{ pkgs, ... }:

{
  home.packages = with pkgs; [ httpie jq ngrok wrk ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ../config/vimrc.vim;
    plugins = with pkgs.vimPlugins; [
        # LSP
        ale

        # Syntax
        vim-nix
        vim-python-pep8-indent
        semshi
        haskell-vim
        kotlin-vim

        # Clojure
        vim-fireplace
        vim-clojure-highlight
        vim-clojure-static

        # Visuals
        rainbow_parentheses-vim
        vim-airline
        vim-airline-themes
        vim-vinegar

        # Utils
        vim-commentary
        vim-dadbod
        vim-dispatch
    ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };
}
