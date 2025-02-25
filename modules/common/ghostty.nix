# [home-manager]
{lib, ...}: {
  programs.ghostty = {
    enable = true;
    # On macOS the nix build of ghostty is broken
    package = lib._.brew-alias "ghostty";
    enableZshIntegration = true;
    settings = {
      theme = "dark:rose-pine,light:rose-pine-dawn";
      macos-titlebar-style = "tabs";
      window-padding-x = 10;
      window-padding-y = 10;
    };
  };
}
