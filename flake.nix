{
  description = "My NixOS, macOS and home-manager configurations";

  outputs = inputs:
    import ./bootstrap.nix inputs {
      aarch64-darwin = {
        hosts.nyckelharpa = ./hosts/nyckelharpa;
        homes.jakub-nyckelharpa = ./homes/jakub-nyckelharpa;
        hosts.sitar = ./hosts/sitar;
        homes.jakub-sitar = ./homes/jakub-sitar;
      };
      x86_64-linux = {
        hosts.harmonium = ./hosts/harmonium;
        homes.jakub-harmonium = ./homes/jakub-harmonium;
        hosts.lur = ./hosts/lur;
        homes.jakub-lur = ./homes/jakub-lur;
      };
      aarch64-linux = {
        hosts.organ = ./hosts/organ;
        homes.jakub-organ = ./homes/jakub-organ;
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
}
