inputs @ {
  agenix,
  home-manager,
  nix-darwin,
  nixpkgs,
  self,
  ...
}: systems: let
  mapSystem = system: {
    homes ? {},
    hosts ? {},
  }: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    lib = pkgs.lib.extend (lib: super: let
      # Automatically detect all .nix files in lib/ directory, excluding default.nix
      libs =
        builtins.filter
        (path: path != "default.nix" && lib.strings.hasSuffix ".nix" path)
        (builtins.attrNames (builtins.readDir ./.));
      importLib = path: import ./${path} {inherit inputs lib pkgs system;};
    in {
      # Expose custom lib extensions via `_.` prefix
      _ = lib.foldr (a: b: a // b) {} (map importLib libs);
      # Make sure to keep library extensions from home-manager
      hm = home-manager.lib.hm;
    });

    systemSpecifics =
      if system == "aarch64-darwin" || system == "x86_64-darwin"
      then {
        fn = nix-darwin.lib.darwinSystem;
        option = "darwinConfigurations";
        command = "darwin-rebuild";
        agenixModule = agenix.darwinModules.default;
      }
      else {
        fn = nixpkgs.lib.nixosSystem;
        option = "nixosConfigurations";
        command = "nixos-rebuild";
        agenixModule = agenix.nixosModules.default;
      };

    mapHosts = builtins.mapAttrs (name: path:
      systemSpecifics.fn {
        inherit system;
        specialArgs = {inherit inputs lib pkgs self system;};
        modules =
          [
            ../config.nix
            systemSpecifics.agenixModule
            {
              environment.systemPackages = [agenix.packages.${system}.default];
              networking.hostName = name;
            }
            path
          ]
          ++ lib._.autoloadedModules;
      });

    mapHomes = builtins.mapAttrs (name: path:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs lib system;};
        modules = [../config.nix agenix.homeManagerModules.default path] ++ lib._.autoloadedModules;
      });
  in {
    formatter.${system} = pkgs.alejandra;
    devShells.${system}.default = pkgs.mkShell {
      packages = [pkgs.alejandra pkgs.home-manager];
      shellHook = ''
        # Set custom prompt colors using ANSI escape codes
        # \[\e[1;32m\] - Bold Green
        # \[\e[1;34m\] - Bold Blue
        # \[\e[0m\] - Reset formatting
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
in
  builtins.zipAttrsWith
  (name: values: builtins.foldl' (a: b: a // b) {} values)
  (builtins.map (system: mapSystem system systems.${system}) (builtins.attrNames systems))
