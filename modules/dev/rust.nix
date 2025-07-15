# [home-manager]
{
  config,
  lib,
  ...
}: {
  imports = [./mise.nix];

  programs.mise.globalConfig = {
    tools.rust = {
      # pin versions for better reproducibility
      version = "1.88";
      components = "rust-analyzer";
    };
    settings = {
      rust = lib.mkIf config.xdg.enable {
        cargo_home = config.home.sessionVariables.CARGO_HOME;
        rustup_home = config.home.sessionVariables.RUSTUP_HOME;
      };
    };
  };
}
