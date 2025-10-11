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
#   <architecture> = ["hostname1" "hostname2"];
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

  mapSystem = system: hostnames: let
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

    mapHosts = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = systemSpecifics.fn {
          inherit system;
          specialArgs = {
            inherit inputs lib self system;
            hostName = hostname;
          };
          modules = [./hosts/${hostname} systemSpecifics.sopsModule] ++ lib.autoloadedModules;
        };
      })
      hostnames);

    mapHomes = builtins.listToAttrs (map (hostname: {
        name = hostname;
        value = lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs lib system;
            homeName = hostname;
          };
          modules = [./homes/${hostname} sops-nix.homeManagerModules.sops] ++ lib.autoloadedModules;
        };
      })
      hostnames);
  in {
    formatter.${system} = pkgs.alejandra;
    devShells.${system}.default = pkgs.mkShell {
      packages = [pkgs.alejandra pkgs.home-manager];
      shellHook = ''
        export PS1='\[\e[1;32m\][${system}:\w]\$\[\e[0m\] '
        echo
        echo "‹os›: ${builtins.concatStringsSep ", " hostnames}"
        echo "‹hm›: ${builtins.concatStringsSep ", " hostnames}"
        echo

        hm() {
          home-manager switch --flake .#$1
        }

        os() {
          ${systemSpecifics.command} switch --flake .#$1
        }
      '';
    };
    ${systemSpecifics.option} = mapHosts;
    homeConfigurations = mapHomes;
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
