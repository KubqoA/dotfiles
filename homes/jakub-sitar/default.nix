{lib, ...}: {
  imports = lib.imports [
    "hm/aliases"
    "hm/fish"
    "hm/ghostty"
    "hm/git"
    "hm/home"
    "hm/neovim"
    "hm/ssh"
    "hm/xdg"
    "hm/dev/js"
  ];

  home = {
    sessionVariables = {
      # Inlined from eval "$(/opt/homebrew/bin/brew shellenv)"
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info:''${INFOPATH:-}";

      # Include Homebrew and Orbstack in the PATH
      PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:$PATH:/Users/jakub/.orbstack/bin";

      # Fix Homebrew libs
      LDFLAGS = "-L/opt/homebrew/lib";
      CPPFLAGS = "-I/opt/homebrew/include";
    };

    file = {
      # Disable the Last login message in the terminal
      ".hushlogin".text = "";
    };
  };

  programs = {
    zoxide.enable = true;
  };

  home.stateVersion = "24.05";
}
