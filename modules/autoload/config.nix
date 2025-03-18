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
    homePath =
      lib.mkDefault
      {
        x86_64-linux = "/home/${config.username}";
        aarch64-linux = "/home/${config.username}";
        aarch64-darwin = "/Users/${config.username}";
      }
      .${system};
    # gpg --list-secret-keys --keyid-format=long --with-keygrip
    gitSigningKey = "3F6BC2C89D644E2A";
    gpgSshControl = ''
      CC54AAD6EF69F323DEB5CDDF9521D2F679686C9E
      8B9C3AD17594CA999C879DEE644A8F8D9D61DB05
    '';
    # ssh-add -L
    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHP5frSskVtjewKR1Bg2U7DFyG/o9HmwaRKbX8vnnEW+";
  };
}
