# [home-manager]
{
  config,
  lib,
  ...
}: {
  imports = [./mise.nix];

  programs.mise.globalConfig = {
    # pin versions for better reproducibility
    tools = {
      rust = {
        version = "1.87";
        components = "rust-analyzer";
      };
    };
    settings = {
      rust = lib.mkIf config.xdg.enable {
        cargo_home = config.home.sessionVariables.CARGO_HOME;
        rustup_home = config.home.sessionVariables.RUSTUP_HOME;
      };
    };
  };
}
