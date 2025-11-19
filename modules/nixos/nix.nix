# nix with sensible defaults
# inspired by:
# - https://github.com/nix-community/srvos/blob/main/nixos/common/nix.nix
# - https://github.com/nix-community/srvos/blob/main/shared/common/nix.nix
{
  inputs,
  lib,
  ...
}: {
  nix = {
    # Disable nix channels. Use flakes instead.
    channel.enable = false;

    settings = {
      # Enable support for nix commands and flakes
      experimental-features = ["nix-command" "flakes"];

      # If the user is in @wheel they are trusted by default.
      trusted-users = ["@wheel"];

      # The default at 10 is rarely enough.
      log-lines = 25;

      # Avoid disk full issues
      max-free = 3000 * 1024 * 1024;
      min-free = 512 * 1024 * 1024;

      # Avoid copying unnecessary stuff over SSH
      builders-use-substitutes = true;

      # Fallback quickly if substituters are not available.
      connect-timeout = 5;

      warn-dirty = false;
    };

    # Pinning the registry to the system pkgs on NixOS
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Binding `<nixpkgs>` to the flake input, and similar for other flake inputs
    nixPath =
      lib.mapAttrsToList (name: value: "${name}=${value}")
      (lib.filterAttrs (_: value: value ? _type && value._type == "flake") inputs);

    # https://wiki.nixos.org/wiki/Storage_optimization#Automatic
    optimise.automatic = true;

    # https://wiki.nixos.org/wiki/Storage_optimization#Automation
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
}
