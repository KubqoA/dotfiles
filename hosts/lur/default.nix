{
  config,
  inputs,
  lib,
  ...
}: {
  imports = lib.imports [
    inputs.nixos-wsl.nixosModules.wsl
    "nixos/base"
  ];

  programs.nix-ld.enable = true;

  wsl = {
    enable = true;
    defaultUser = config.username;
  };
}
