# [home-manager]
{
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    # On macOS the nix build of ghostty is broken
    package = lib.brew-alias pkgs "ghostty";
    enableZshIntegration = true;
    settings = {
      theme = "dark:kanso-zen,light:kanso-pearl";
      macos-titlebar-style = "tabs";
      window-padding-x = 10;
      window-padding-y = 10;
      font-family = "JetBrainsMono Nerd Font Mono";
    };
    themes = {
      kanso-zen = {
        background = "#090E13";
        foreground = "#c5c9c7";
        cursor-color = "#c5c9c7";
        selection-background = "#24262D";
        selection-foreground = "#c5c9c7";
        palette = [
          "0=#090E13"
          "1=#c4746e"
          "2=#8a9a7b"
          "3=#c4b28a"
          "4=#8ba4b0"
          "5=#a292a3"
          "6=#8ea4a2"
          "7=#c8c093"
          "8=#a4a7a4"
          "9=#e46876"
          "10=#87a987"
          "11=#e6c384"
          "12=#7fb4ca"
          "13=#938aa9"
          "14=#7aa89f"
          "15=#c5c9c7"
        ];
      };
      kanso-pearl = {
        background = "#f2f1ef";
        foreground = "#24262D";
        cursor-color = "#24262D";
        selection-background = "#e2e1df";
        selection-foreground = "#24262D";
        palette = [
          "0=#24262D"
          "1=#c84053"
          "2=#6f894e"
          "3=#77713f"
          "4=#4d699b"
          "5=#b35b79"
          "6=#597b75"
          "7=#545464"
          "8=#5C6068"
          "9=#d7474b"
          "10=#6e915f"
          "11=#836f4a"
          "12=#6693bf"
          "13=#624c83"
          "14=#5e857a"
          "15=#f2f1ef"
        ];
      };
    };
  };
}
