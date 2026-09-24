# Global configuration options that can be referenced by all modules
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    username = mkOption {type = types.str;};
    uid = mkOption {type = types.int;};
    homePath = mkOption {type = types.str;};
    dotfilesPath = mkOption {type = types.str;};
    sshPublicKeys = mkOption {type = types.listOf types.str;};
  };

  config = {
    # Primary user of the systems, home configs set it from `./homes/<hostname>/<username>.nix`
    username = mkDefault "jakub";
    uid = mkDefault 501;
    homePath =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Users/${config.username}"
      else "/home/${config.username}";
    dotfilesPath =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "${config.homePath}/.config/dotfiles"
      else "/persist/dotfiles";
    sshPublicKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPplCI6xumDIAyKig2qj/WA/UyyVmw79nSdxv0J84CJl jakub@lur"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWaSqYW6qT2duI6wGyefAWHRI3x0oyj6tAOMh7fD8dl jakub@harmonium"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAzB/MNk46dD3VE4W7nK03iK0VACFGYs5S5Uc9JucsWQ jakub@nyckelharpa"
    ];
  };
}
