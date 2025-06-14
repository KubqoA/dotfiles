{
  description = "My NixOS, macOS and home-manager configurations";

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

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
}
