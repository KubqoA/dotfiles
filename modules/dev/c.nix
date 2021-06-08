{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.c;
in {
  options.modules.dev.c = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      clang
      clang-tools
      cppcheck
      gcc
      gnumake
      cmake
      valgrind
      binutils
      lld
      llvm
    ];
  };
}
