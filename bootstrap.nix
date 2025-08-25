# Turns the abstract per system configuration in ‹flake.nix› to individual
# nixos, darwin and home-manager configs. Additionally for each system architecture
# defines formatting with ‹nix fmt› and a custom ‹nix develop› shell with helpers
# for activating configurations on new machines. Also defines a custom lib with
# extensions defined in ‹lib.nix›.
#
# For all nixos, darwin, and home-manager config autoloads ‹config.nix›, agenix, and
# all autoloaded modules.
#
# Usage:
# ```
# import ./bootstrap.nix inputs {
#   <architecture> = {
#     homes.<name> = path;
#     systems.<name> = path;
#   };
# }
# ```
inputs @ {
  nixpkgs,
  self,
  sops-nix,
  ...
}: systems: let
  # system agnostic lib with custom extensions
  lib = nixpkgs.lib.extend (import ./lib.nix inputs);

  inherit (lib) foldl recursiveUpdate mapAttrsToList;

  mapSystem = system: {
    homes ? {},
    hosts ? {},
  }: let
    pkgs = nixpkgs.legacyPackages.${system};

    systemSpecifics =
      if pkgs.stdenv.isDarwin
      then {
        fn = lib.darwinSystem;
        option = "darwinConfigurations";
        command = "sudo nix run nix-darwin --";
        sopsModule = sops-nix.darwinModules.sops;
      }
      else {
        fn = lib.nixosSystem;
        option = "nixosConfigurations";
        command = "sudo nixos-rebuild";
        sopsModule = sops-nix.nixosModules.sops;
      };

    mapHosts = builtins.mapAttrs (hostName: path:
      systemSpecifics.fn {
        inherit system;
        specialArgs = {inherit inputs lib self system hostName;};
        modules = [path systemSpecifics.sopsModule] ++ lib.autoloadedModules;
      });

    mapHomes = builtins.mapAttrs (homeName: path:
      lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs lib system homeName;};
        modules = [path sops-nix.homeManagerModules.sops] ++ lib.autoloadedModules;
      });
  in {
    formatter.${system} = pkgs.alejandra;
    devShells.${system}.default = pkgs.mkShell {
      packages = [pkgs.alejandra pkgs.home-manager];
      shellHook = ''
        export PS1='\[\e[1;32m\][${system}:\w]\$\[\e[0m\] '
        echo
        echo "‹os›: ${builtins.concatStringsSep ", " (builtins.attrNames hosts)}"
        echo "‹hm›: ${builtins.concatStringsSep ", " (builtins.attrNames homes)}"
        echo

        hm() {
          home-manager switch --flake .#$1
        }

        os() {
          ${systemSpecifics.command} switch --flake .#$1
        }
      '';
    };
    ${systemSpecifics.option} = mapHosts hosts;
    homeConfigurations = mapHomes homes;
  };

  configuration = foldl recursiveUpdate {} (mapAttrsToList mapSystem systems);

  getOptions = configs: foldl recursiveUpdate {} (mapAttrsToList (_: value: value.options) configs);
in
  configuration
  // {
    inherit lib;

    # Merge all options into one attribute set for use with ‹nixd›
    options = {
      nixos = getOptions self.nixosConfigurations;
      darwin = getOptions self.darwinConfigurations;
      home-manager = getOptions self.homeConfigurations;
    };
  }
