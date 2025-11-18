# [home-manager/nixos/nix-darwin]
# Global configuration options that can be referenced by all modules
{
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    username = mkOption {type = types.str;};
    homePath = mkOption {type = types.str;};
    dotfilesPath = mkOption {type = types.str;};
    sshPublicKeys = mkOption {type = types.listOf types.str;};
  };

  config = rec {
    username = "jakub";
    homePath =
      if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    dotfilesPath = "${homePath}/.config/dotfiles";
    sshPublicKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPplCI6xumDIAyKig2qj/WA/UyyVmw79nSdxv0J84CJl jakub@lur"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWaSqYW6qT2duI6wGyefAWHRI3x0oyj6tAOMh7fD8dl jakub@harmonium"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAzB/MNk46dD3VE4W7nK03iK0VACFGYs5S5Uc9JucsWQ jakub@nyckelharpa"
    ];
  };
}
