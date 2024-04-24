{
  description = "My NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # maybe split into separate flake?
    eduroam-muni = {
      url = "https://cat.eduroam.org/user/API.php?action=downloadInstaller&lang=en&profile=1871&device=linux&generatedfor=user&openroaming=0";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # Sets the default formatter that is used when running
    # $ nix fmt
    formatter.${system} = pkgs.alejandra;

    # home-manager configurations defined in a flake can be enabled by running
    # $ nix run home-manager/master -- switch --flake /etc/nixos
    # or in case of username mismatch
    # $ nix run home-manager/master -- switch --flake /etc/nixos#username
    homeConfigurations.jakub = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};

      modules = [./users/jakub];
    };

    nixosConfigurations.harmonium = nixpkgs.lib.nixosSystem {
      inherit (system);
      specialArgs = {inherit system pkgs inputs;};

      modules = [./hosts/harmonium];
    };
  };
}
