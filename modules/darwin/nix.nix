{config, ...}: {
  nix.enable = false; # Required for use with Determinate Nix
  environment.etc."nix/nix.custom.conf".text = ''
    trusted-users = root ${config.username}
    warn-dirty = false
  '';
}
