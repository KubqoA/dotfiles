#   __ _       _                _
#  / _| | __ _| | _____   _ __ (_)_  __
# | |_| |/ _` | |/ / _ \ | '_ \| \ \/ /
# |  _| | (_| |   <  __/_| | | | |>  <
# |_| |_|\__,_|_|\_\___(_)_| |_|_/_/\_\
#
# Author:  Jakub Arbet ‹hi at jakubarbet.me›
# URL:     https://github.com/kubqoa/dotfiles
# License: Unlicense

{
  description = "Monorepo for system configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      mkPkgs = pkgs: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = lib.attrValues self.overlays;
      };

      # Extends pkgs, with custom packages defined via overlays
      pkgs = mkPkgs nixpkgs;

      # Extended lib, with custom modifications living under ‹lib._›
      lib = import ./lib {
        inherit pkgs inputs;
	lib = nixpkgs.lib;
      };

      inherit (lib._) mapModules mapModulesRec mkHost mkPackage;
    in {
      packages."${system}" = mapModules ./packages mkPackage;

      # This overlay binds packages defined above available via ‹pkgs._›
      overlays.default = final: prev: {
        _ = self.packages."${system}";
      };

      nixosModules = mapModulesRec ./modules import;

      nixosConfigurations = mapModules ./hosts (mkHost system);

      devShells."${system}".default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nix
          git
        ];
      };
    };
}
