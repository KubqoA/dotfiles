{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.git.ignores = ["mise.local.toml"];

  programs.mise = {
    enable = true;
    # On macOS manage mise by homebrew - more frequent updates
    package = lib.brew-alias pkgs "mise";
    # globalConfig goes to conf.d/50-home-manager.toml, config.toml stays writable for `mise use -g`
    enableMutableConfig = true;
    # We have programs.nix-ld.enable = true; so we don't need to compile everything
    globalConfig.settings.all_compile = false;
  };

  programs.fish.interactiveShellInit = ''
    ${lib.getExe config.programs.mise.package} activate fish --shims | source
  '';
}
