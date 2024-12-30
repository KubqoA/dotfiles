inputs @ {
  agenix,
  home-manager,
  nix-darwin,
  nixpkgs,
  self,
  ...
}: systems: let
  inherit ((import nixpkgs {system = "x86_64-linux";}).lib) foldl mapAttrsToList recursiveUpdate;

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
        command = "nix run nix-darwin --";
        agenixModule = agenix.darwinModules.default;
      }
      else {
        fn = nixpkgs.lib.nixosSystem;
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
            ../config.nix
            systemSpecifics.agenixModule
            {networking.hostName = lib.mkDefault osName;}
            path
          ]
          ++ lib._.autoloadedModules;
      });

    mapHomes = builtins.mapAttrs (homeName: path:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs lib system homeName;};
        modules =
          [
            ../config.nix
            agenix.homeManagerModules.default
            path
          ]
          ++ lib._.autoloadedModules;
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

  mappedSystems = foldl recursiveUpdate {} (mapAttrsToList mapSystem systems);

  # Merge all options into one attribute set for use with ‹nixd›
  options = let
    getOptions = configs: foldl recursiveUpdate {} (mapAttrsToList (_: value: value.options) configs);
  in {
    nixos = getOptions mappedSystems.nixosConfigurations;
    darwin = getOptions mappedSystems.darwinConfigurations;
    home-manager = getOptions mappedSystems.homeConfigurations;
  };
in
  mappedSystems // {inherit options;}
