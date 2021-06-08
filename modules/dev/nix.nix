{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.nix;
in {
  options.modules.dev.nix = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nixfmt
      nix-linter
      nix-prefetch-git
      nix-prefetch-github
    ];
  };
}
