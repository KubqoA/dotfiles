# [nixos/nix-darwin]
# common packages shared across all systems
{
  inputs,
  pkgs,
  system,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${system}.default
    alejandra
    git
    curl
    wget
    neovim
  ];
}
