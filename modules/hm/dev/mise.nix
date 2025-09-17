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
    # We have programs.nix-ld.enable = true; so we don't need to compile everything
    settings.all_compile = false;
  };
}
