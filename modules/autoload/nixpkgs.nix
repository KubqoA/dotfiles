# [home-manager/nixos/nix-darwin]
# Default nixpkgs settings, enabling unfree packages, and adding overlays
{pkgs, ...}: {
  # Needed otherwise this assertion fails: A corresponding Nix package must be
  # specified via `nix.package` for generating nix.conf
  nix.package = pkgs.nix;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [(final: prev: {})];
}
