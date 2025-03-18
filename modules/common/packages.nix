# [nixos/nix-darwin]
# common packages shared across all systems
{
  inputs,
  pkgs,
  system,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra
    git
    curl
    wget
    neovim
    age
    sops
  ];
}
