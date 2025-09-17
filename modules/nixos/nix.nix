# nix with sensible defaults
{
  config,
  inputs,
  lib,
  system,
  ...
}: {
  nix = {
    # Disable nix channels. Use flakes instead.
    channel.enable = lib.mkDefault false;

    settings = {
      # Enable support for nix commands and flakes
      experimental-features = ["nix-command" "flakes"];

      # If the user is in @wheel they are trusted by default.
      trusted-users = ["root" "@wheel" config.username];

      # The default at 10 is rarely enough.
      log-lines = lib.mkDefault 25;

      # Avoid disk full issues
      max-free = lib.mkDefault (3000 * 1024 * 1024);
      min-free = lib.mkDefault (512 * 1024 * 1024);

      # Avoid copying unnecessary stuff over SSH
      builders-use-substitutes = true;

      # Fallback quickly if substituters are not available.
      connect-timeout = lib.mkDefault 5;

      warn-dirty = false;
    };

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

    # Periodically optimize storage
    # https://nixos.wiki/wiki/Storage_optimization#Automatic
    # You can also manually optimize the store via:
    #    nix-store --optimise
    optimise.automatic = true;
  };
}
