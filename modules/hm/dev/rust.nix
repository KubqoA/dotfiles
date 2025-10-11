{
  config,
  lib,
  ...
}: {
  imports = [./mise.nix];

  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
  };

  programs.mise.globalConfig = {
    tools.rust = {
      # pin versions for better reproducibility
      version = "1.90";
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
