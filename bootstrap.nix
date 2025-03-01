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
  agenix,
  nixpkgs,
  self,
  ...
}: systems: let
  # system agnostic lib with custom extensions
  lib = nixpkgs.lib.extend (import ./lib.nix inputs);

  inherit (lib) foldl recursiveUpdate mapAttrsToList;

  mapSystem = system: {
    homes ? {},
    hosts ? {},
  }: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    systemSpecifics =
      if pkgs.stdenv.isDarwin
      then {
        fn = lib.darwinSystem;
        option = "darwinConfigurations";
        command = "nix run nix-darwin --";
        agenixModule = agenix.darwinModules.default;
      }
      else {
        fn = lib.nixosSystem;
        option = "nixosConfigurations";
        command = "nixos-rebuild";
        agenixModule = agenix.nixosModules.default;
      };

    mapHosts = builtins.mapAttrs (osName: path:
      systemSpecifics.fn {
        inherit system;
        specialArgs = {inherit inputs lib pkgs self system osName;};
        modules =
          [
            ./config.nix
            systemSpecifics.agenixModule
            {networking.hostName = lib.mkDefault osName;}
            path
          ]
          ++ lib.autoloadedModules;
      });

    mapHomes = builtins.mapAttrs (homeName: path:
      lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs lib system homeName;};
        modules =
          [
            ./config.nix
            agenix.homeManagerModules.default
            path
          ]
          ++ lib.autoloadedModules;
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
