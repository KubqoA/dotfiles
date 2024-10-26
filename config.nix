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
    gitSigningKey = mkOption {type = types.str;};
    gpgSshControl = mkOption {type = types.str;};
    sshPublicKey = mkOption {type = types.str;};
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
      .${system};
    gitSigningKey = "4EB39A80B52672EC";
    gpgSshControl = "CC54AAD6EF69F323DEB5CDDF9521D2F679686C9E";
    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJP8m7CjSO/Rme3xkIAnvQrVi0AUnLGwDm5DoM6JucWj";
  };
}
