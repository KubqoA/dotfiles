# [home-manager]
{
  lib,
  pkgs,
  ...
}: {
  programs.git.ignores = ["mise.local.toml"];

  programs.mise = {
    enable = true;
    # On macOS manage mise by homebrew - more frequent updates
    package = lib.brew-alias pkgs "mise";
  };
}
