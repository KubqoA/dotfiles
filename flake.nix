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

    # nixpkgs with working and cached swift build
    darwin-nixpkgs.url = "github:nixos/nixpkgs?rev=2e92235aa591abc613504fde2546d6f78b18c0cd";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    rose-pine-kitty.url = "github:rose-pine/kitty";
    rose-pine-kitty.flake = false;
  };

  outputs = inputs:
    import ./lib inputs {
      aarch64-darwin = {
        homes.jakub-macos = ./homes/jakub-macos;
        hosts.nyckelharpa = ./hosts/nyckelharpa;
      };
      x86_64-linux = {
        homes.jakub-x86 = ./homes/jakub-linux;
        hosts.harmonium = ./hosts/harmonium;
      };
      aarch64-linux = {
        homes.jakub-arm64 = ./homes/jakub-linux;
        hosts.organ = ./hosts/organ;
      };
    };
}
