{ lib, inputs, pkgs, ... }:

let
  inherit (lib) nixosSystem mkDefault;
in {
  /* 
  */
  mkHost = system: path:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault (baseNameOf path);
        }
        ../.
        (import path)
      ];
    };
}
