{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets = lib.defineSecrets {organ-jakub-password-hash = {};};

  users.users = {
    ${config.username} = {
      hashedPasswordFile = config.age.secrets.organ-jakub-password-hash.path;
      openssh.authorizedKeys.keys = [config.sshPublicKey];
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
    };
  };

  programs.zsh.enable = true;
}
