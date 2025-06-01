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

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
    simple-nixos-mailserver.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs = inputs:
    import ./bootstrap.nix inputs {
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
