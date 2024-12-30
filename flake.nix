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

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    ghostty.url = "github:ghostty-org/ghostty";
    ghostty.inputs.nixpkgs-unstable.follows = "nixpkgs";
  };

  outputs = inputs:
    import ./lib inputs {
      aarch64-darwin = {
        homes.jakub-macos = ./homes/jakub-macos;
        hosts.nyckelharpa = ./hosts/nyckelharpa;
      };
      x86_64-linux = {
        homes.jakub-nixos = ./homes/jakub-nixos;
        hosts.harmonium = ./hosts/harmonium;
      };
      aarch64-linux = {
        homes.jakub-server = ./homes/jakub-server;
        hosts.organ = ./hosts/organ;
      };
    };
}
