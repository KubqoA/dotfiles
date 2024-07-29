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
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    linuxSystem = "x86_64-linux";
    macosSystem = "aarch64-darwin";
    linuxPkgs = mkPkgs linuxSystem;
    macosPkgs = mkPkgs macosSystem;
  in {
    # Sets the default formatter that is used when running
    # $ nix fmt
    formatter.${linuxSystem} = linuxPkgs.alejandra;
    formatter.${macosSystem} = macosPkgs.alejandra;

    # home-manager configurations defined in a flake can be enabled by running
    # $ nix run home-manager/master -- switch --flake dotfiles
    # or in case of username mismatch
    # $ nix run home-manager/master -- switch --flake dotfiles
    homeConfigurations.jakub = home-manager.lib.homeManagerConfiguration {
      pkgs = linuxPkgs;
      extraSpecialArgs = {inherit inputs;};

      modules = [./users/jakub-linux];
    };

    # nixos configurations defined in a flake can be enabled by running
    # $ nixos-rebuild switch --flake dotfiles
    nixosConfigurations.harmonium = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        system = linuxSystem;
        pkgs = linuxPkgs;
      };
      system = linuxSystem;

      modules = [./hosts/harmonium];
    };

    # nix-darwin configurations defined in a flake can be enabled by running
    # $ darwin-rebuild build --flake dotfiles#nyckelharpa
    darwinConfigurations.nyckelharpa = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit self inputs;
        system = macosSystem;
      };
      system = macosSystem;

      modules = [
        ./hosts/nyckelharpa

        # Include the home-manager module directly inside the darwin conf
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jakub = import ./users/jakub-macos;
        }
      ];
    };
  };
}
