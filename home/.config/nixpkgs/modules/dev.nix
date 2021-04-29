{ pkgs, ... }:

let
  vscode-insiders = pkgs.callPackage ../pkgs/vscode-insiders {};
  tableplus = pkgs.callPackage ../pkgs/tableplus {};
in
{
  home.packages = with pkgs; [
    httpie jq ngrok wrk python38Packages.pynvim heroku
    tableplus exercism
  ];

  home.file.".config/clojure/deps.edn".source = ../config/clojure/deps.edn;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ../config/vimrc.vim;
    plugins = let
      clojure-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "clojure.vim";
        version = "2021-03-04";
        src = pkgs.fetchFromGitHub {
          owner = "clojure-vim";
          repo = "clojure.vim";
          rev = "d9e7dceba889d2552f3d667657eb9b29d57a8f45";
          sha256 = "00k7cix90n6rqv8c7d7wqklnzw43d5xy64bnm60pj10r4axpj1fl";
        };
        meta.homepage = "https://github.com/clojure-vim/clojure.vim";
      };
      vim-dispatch-neovim = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "vim-dispatch-neovim";
        version = "2017-06-18";
        src = pkgs.fetchFromGitHub {
          owner = "radenling";
          repo = "vim-dispatch-neovim";
          rev = "c8c4e21a95c25032a041002f9bf6e45a75a73021";
          sha256 = "111n3f7lv9nkpj200xh0fwbi3scjqyivpw5fwdjdyiqzd6qabxml";
        };
        meta.homepage = "https://github.com/radenling/vim-dispatch-neovim/";
      };
      vim-jack-in = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "vim-jack-in";
        version = "2020-06-25";
        src = pkgs.fetchFromGitHub {
          owner = "clojure-vim";
          repo = "vim-jack-in";
          rev = "a89a3332cfcf274319e0723f2762ed46f0786d93";
          sha256 = "06fhmz5kjqfb7bxvwcz0wc3as79a3sgxayxgvn5adhiy29mp0r33";
        };
        meta.homepage = "https://github.com/clojure-vim/vim-jack-in";
      };
      deoplete-clangx = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "deoplete-clangx";
        version = "2020-06-19";
        src = pkgs.fetchFromGitHub {
          owner = "Shougo";
          repo = "deoplete-clangx";
          rev = "0157512796f63d33091a98a19bbea8b57e227a8f";
          sha256 = "0f2f5brcgb3m2v3yz3nhc09pfjdyzglcgzj5kp7z30i1z8p3vz5s";
        };
        meta.homepage = "https://github.com/Shougo/deoplete-clangx";
      };
      vim-dadbod-ui = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "vim-dadbod-ui";
        version = "2021-02-28";
        src = pkgs.fetchFromGitHub {
          owner = "kristijanhusak";
          repo = "vim-dadbod-ui";
          rev = "2711d4429643f52985cb55393a1a161331211a16";
          sha256 = "1mdagk4a6pvwcix5jplvwmz6788kfy827vj7h5qv1hk91rh6gip2";
        };
        meta.homepage = "https://github.com/kristijanhusak/vim-dadbod-ui";
      };
    in with pkgs.vimPlugins; [
        # LSP
        ale

        # Autocomplete
        deoplete-nvim
        float-preview-nvim
        deoplete-clangx
        neco-ghc

        # Syntax
        vim-nix
        vim-python-pep8-indent
        semshi
        haskell-vim
        kotlin-vim

        # Clojure
        clojure-vim
        conjure
        vim-jack-in

        # Lisp editing
        vim-sexp
        vim-sexp-mappings-for-regular-people
        pkgs.parinfer-rust

        # Visuals
        vim-airline
        vim-airline-themes
        vim-vinegar

        # Utils
        vim-commentary
        vim-dadbod
        vim-dadbod-ui
        vim-dispatch
        vim-dispatch-neovim
        vim-gitgutter
        vim-clap
        auto-pairs
    ];
  };

  programs.vscode = {
    enable = true;
    package = vscode-insiders;
  };
}
