# [home-manager/nixos/nix-darwin]
# Default nixpkgs settings, enabling unfree packages, and adding overlays
{...}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [(final: prev: {})];
}
