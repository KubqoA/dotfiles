# [nixos/nix-darwin]
# common packages shared across all systems
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    age
    alejandra
    curl
    git
    neovim
    nurl
    ripgrep
    sops
    tldr
    wget
  ];
}
