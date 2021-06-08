#   __ _       _                _
#  / _| | __ _| | _____   _ __ (_)_  __
# | |_| |/ _` | |/ / _ \ | '_ \| \ \/ /
# |  _| | (_| |   <  __/_| | | | |>  <
# |_| |_|\__,_|_|\_\___(_)_| |_|_/_/\_\
#
# > Where the snow paradise begins
#
# Author:  Jakub Arbet ‹hi at jakubarbet.me›
# URL:     https://github.com/kubqoa/dotfiles
# License: Unlicense

{
  description = "Winter snow";

  inputs = {
    # NixOs 21.05
    nixpkgs.url = "nixpkgs/nixos-21.05";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Extras
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      lib = import ./lib { inherit pkgs inputs; lib = nixpkgs.lib; };

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ self.overlay ] ++ (lib.attrValues self.overlays);
      };

      inherit (lib._) mapModules mapModulesRec mkHost;
    in {
      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p {});

      # This overlay binds packages defined above available via ‹pkgs._›
      overlay = final: prev: { _ = self.packages."${system}"; };

      overlays = mapModules ./overlays import;

      nixosModules = mapModulesRec ./modules import;

      nixosConfigurations = mapModules ./hosts (mkHost system);

      devShell."${system}" =
        import ./shell.nix { inherit pkgs; };
    };
}
