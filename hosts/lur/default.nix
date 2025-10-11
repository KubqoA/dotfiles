{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = lib.imports [
    inputs.nixos-wsl.nixosModules.wsl
    "nixos/nix"
    "nixos/packages"
    "nixos/sudo"
  ];

  programs = {
    fish.enable = true;
    nix-ld.enable = true;
  };

  users.users.${config.username} = {
    home = config.homePath;
    shell = pkgs.fish;
    uid = 1000;
  };

  wsl = {
    enable = true;
    defaultUser = config.username;
  };

  system.stateVersion = "25.11";
}
