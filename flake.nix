{
  description = "My NixOS, macOS and home-manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "nix-darwin";
    agenix.inputs.home-manager.follows = "home-manager";

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
    simple-nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let
    lib = import ./lib inputs;
  in {
    # Sets the default formatter that is used when running
    # $ nix fmt
    formatter = lib.formatter;

    # home-manager configurations defined in a flake can be enabled by running
    # $ nix run home-manager/master -- switch --flake "dotfiles#jakub-macos"
    homeConfigurations.jakub-x86 = lib.linuxHome-x86 ./users/jakub-linux;
    homeConfigurations.jakub-arm64 = lib.linuxHome-arm64 ./users/jakub-linux;
    homeConfigurations.jakub-macos = lib.macosHome ./users/jakub-macos;

    # nixos configurations defined in a flake can be enabled by running
    # $ nixos-rebuild switch --flake dotfiles#harmonium
    # $ nixos-rebuild switch --flake dotfiles#organ
    nixosConfigurations.harmonium = lib.nixosSystem-x86 ./hosts/harmonium;
    nixosConfigurations.organ = lib.nixosSystem-arm64 ./hosts/organ;

    # nix-darwin configurations defined in a flake can be enabled by running
    # $ darwin-rebuild build --flake dotfiles#nyckelharpa
    darwinConfigurations.nyckelharpa = lib.macosSystem ./hosts/nyckelharpa;
  };
}
