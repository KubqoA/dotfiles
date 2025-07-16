# [home-manager/nixos/nix-darwin]
# Global configuration options that can be referenced by all modules
{
  config,
  lib,
  system,
  ...
}:
with lib; {
  options = {
    username = mkOption {type = types.str;};
    dotfilesPath = mkOption {type = types.str;};
    homePath = mkOption {type = types.str;};
    sshPublicKeys = mkOption {type = types.listOf types.str;};
  };

  config = {
    username = "jakub";
    dotfilesPath =
      lib.mkDefault
      {
        "x86_64-linux" = "/persist/dotfiles";
        "aarch64-linux" = "/persist/dotfiles";
        "aarch64-darwin" = "/Users/${config.username}/.config/dotfiles";
      }
      .${
        system
      };
    homePath =
      lib.mkDefault
      {
        x86_64-linux = "/home/${config.username}";
        aarch64-linux = "/home/${config.username}";
        aarch64-darwin = "/Users/${config.username}";
      }
      .${
        system
      };
    sshPublicKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPplCI6xumDIAyKig2qj/WA/UyyVmw79nSdxv0J84CJl jakub@lur"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWaSqYW6qT2duI6wGyefAWHRI3x0oyj6tAOMh7fD8dl jakub@harmonium"
    ];
  };
}
