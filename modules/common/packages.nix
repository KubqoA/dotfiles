# [nixos/nix-darwin]
# common packages shared across all systems
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    git
    curl
    wget
    neovim
    age
    sops
    ripgrep
  ];
}
