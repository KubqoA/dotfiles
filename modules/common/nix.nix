# [nixos/nix-darwin]
# nix with sensible defaults
{
  inputs,
  lib,
  system,
  ...
}: {
  nix = {
    # Enable support for nix commands and flakes
    settings.experimental-features = ["nix-command" "flakes"];

    # Pinning the registry to the system pkgs on NixOS
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Perform garbage collection weekly to maintain low disk usage
    gc = {
      automatic = true;
      dates = lib.mkIf (system != "aarch64-darwin") "weekly";
      options = "--delete-older-than 1w";
    };

    # Optimize storage
    # You can also manually optimize the store via:
    #    nix-store --optimise
    # Refer to the following link for more details:
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    settings.auto-optimise-store = true;
  };
}
