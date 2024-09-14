# Simple lib for moving configuration boilerplate out of the main flake.nix
# Contains helpers to define home-manager, nix-darwin, and nixos systems
# and to load custom lib extensions from other .nix files in lib/ directory
inputs @ {
  agenix,
  home-manager,
  nixpkgs,
  nix-darwin,
  self,
  ...
}: let
  macosSystem = "aarch64-darwin";
  linuxSystem-x86 = "x86_64-linux";
  linuxSystem-arm64 = "aarch64-linux";
  macosPkgs = makePkgs macosSystem;
  linuxPkgs-x86 = makePkgs linuxSystem-x86;
  linuxPkgs-arm64 = makePkgs linuxSystem-arm64;

  makePkgs = system:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  # Expose custom lib extensions via `_.` prefix
  makeLib = pkgs: extra:
    pkgs.lib.extend (lib: super: let
      # Automatically detect all .nix files in lib/ directory, excluding default.nix
      libs =
        builtins.filter
        (path: path != "default.nix" && lib.strings.hasSuffix ".nix" path)
        (builtins.attrNames (builtins.readDir ./.));
      importLib = path: import ./${path} {inherit inputs lib pkgs;};
    in
      {
        _ = lib.foldr (a: b: a // b) {} (map importLib libs);
      }
      // extra);

  makeHome = system: pkgs: path:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs system;
        # Make sure to keep library extensions from home-manager
        lib = makeLib pkgs home-manager.lib;
      };
      modules = [../config.nix agenix.homeManagerModules.default path];
    };

  makeSystem = systemFn: system: pkgs: path:
    systemFn {
      inherit system;
      specialArgs = {
        inherit inputs pkgs self system;
        lib = makeLib pkgs {};
      };
      modules = let
        agenixModule =
          {
            ${macosSystem} = agenix.darwinModules.default;
            ${linuxSystem-x86} = agenix.nixosModules.default;
            ${linuxSystem-arm64} = agenix.nixosModules.default;
          }
          .${system};
      in [
        ../config.nix
        agenixModule
        {environment.systemPackages = [agenix.packages.${system}.default];}
        path
      ];
    };
in {
  formatter = {
    ${macosSystem} = macosPkgs.alejandra;
    ${linuxSystem-x86} = linuxPkgs-x86.alejandra;
    ${linuxSystem-arm64} = linuxPkgs-arm64.alejandra;
  };

  macosHome = makeHome macosSystem macosPkgs;
  linuxHome-x86 = makeHome linuxSystem-x86 linuxPkgs-x86;
  linuxHome-arm64 = makeHome linuxSystem-arm64 linuxPkgs-arm64;

  macosSystem = makeSystem (nix-darwin.lib.darwinSystem) macosSystem macosPkgs;
  nixosSystem-x86 = makeSystem (nixpkgs.lib.nixosSystem) linuxSystem-x86 linuxPkgs-x86;
  nixosSystem-arm64 = makeSystem (nixpkgs.lib.nixosSystem) linuxSystem-arm64 linuxPkgs-arm64;
}
