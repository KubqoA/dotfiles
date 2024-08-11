# Simple lib for moving configuration boilerplate out of the main flake.nix
# Contains helpers to define home-manager, nix-darwin, and nixos systems
# and to load custom lib extensions from other .nix files in lib/ directory
inputs @ {
  home-manager,
  nixpkgs,
  nix-darwin,
  self,
  ...
}: let
  linuxSystem = "x86_64-linux";
  macosSystem = "aarch64-darwin";
  linuxPkgs = makePkgs linuxSystem;
  macosPkgs = makePkgs macosSystem;

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

  makeHome = pkgs: path:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
        # Make sure to keep library extensions from home-manager
        lib = makeLib pkgs home-manager.lib;
      };
      modules = [../config.nix path];
    };

  makeSystem = systemFn: system: pkgs: path:
    systemFn {
      inherit system;
      specialArgs = {
        inherit inputs pkgs self system;
        lib = makeLib pkgs {};
      };
      modules = [../config.nix path];
    };
in {
  formatter = {
    ${macosSystem} = macosPkgs.alejandra;
    ${linuxSystem} = linuxPkgs.alejandra;
  };

  macosHome = makeHome macosPkgs;
  linuxHome = makeHome linuxPkgs;

  macosSystem = makeSystem (nix-darwin.lib.darwinSystem) macosSystem macosPkgs;
  nixosSystem = makeSystem (nixpkgs.lib.nixosSystem) linuxSystem linuxPkgs;
}
