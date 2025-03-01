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
      theme = "dark:rose-pine,light:rose-pine-dawn";
      macos-titlebar-style = "tabs";
      window-padding-x = 10;
      window-padding-y = 10;
    };
  };
}
