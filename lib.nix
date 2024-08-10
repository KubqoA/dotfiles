# Simple lib for moving configuration boilerplate out of the main flake.nix
# Contains helpers to define home-manager, nix-darwin, and nixos systems
inputs @ {
  home-manager,
  nixpkgs,
  nix-darwin,
  self,
  ...
}: let
  mkPkgs = system:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  linuxSystem = "x86_64-linux";
  macosSystem = "aarch64-darwin";
  linuxPkgs = mkPkgs linuxSystem;
  macosPkgs = mkPkgs macosSystem;

  makeHome = pkgs: path:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules = [path];
    };

  makeSystem = systemFn: system: pkgs: path:
    systemFn {
      inherit system;
      specialArgs = {inherit inputs self system pkgs;};
      modules = [path];
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
