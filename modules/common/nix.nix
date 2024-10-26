# [nixos/nix-darwin]
# nix with sensible defaults
{
  config,
  inputs,
  lib,
  system,
  ...
}: {
  nix = {
    # Enable support for nix commands and flakes
    settings.experimental-features = ["nix-command" "flakes"];

    settings.trusted-users = ["root" config.username];

    # Pinning the registry to the system pkgs on NixOS
    registry.nixpkgs.flake = inputs.nixpkgs;
    # Binding `<nixpkgs>` to the flake input, and similar for other flake inputs
    nixPath =
      lib.mapAttrsToList (name: value: "${name}=${value}")
      (lib.filterAttrs (_: value: value ? _type && value._type == "flake") inputs);

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

  nixpkgs.config.allowUnfree = true;
}
