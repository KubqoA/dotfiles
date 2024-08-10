{
  description = "My NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Split into a separate flake
    eduroam-muni = {
      url = "https://cat.eduroam.org/user/API.php?action=downloadInstaller&lang=en&profile=1871&device=linux&generatedfor=user&openroaming=0";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  }: let
    lib = import ./lib.nix inputs;
  in {
    # Sets the default formatter that is used when running
    # $ nix fmt
    formatter = lib.formatter;

    # home-manager configurations defined in a flake can be enabled by running
    # $ nix run home-manager/master -- switch --flake dotfiles
    # or in case of username mismatch, e.g. jakub vs jakub-macos
    # $ nix run home-manager/master -- switch --flake dotfiles#jakub-macos
    homeConfigurations.jakub = lib.linuxHome ./users/jakub-linux;
    homeConfigurations.jakub-macos = lib.macosHome ./users/jakub-macos;

    # nixos configurations defined in a flake can be enabled by running
    # $ nixos-rebuild switch --flake dotfiles
    nixosConfigurations.harmonium = lib.nixosSystem ./hosts/harmonium;

    # nix-darwin configurations defined in a flake can be enabled by running
    # $ darwin-rebuild build --flake dotfiles#nyckelharpa
    darwinConfigurations.nyckelharpa = lib.macosSystem ./hosts/nyckelharpa;
  };
}
