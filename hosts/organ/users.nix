{
  config,
  lib,
  ...
}: {
  age.secrets = lib._.defineSecrets ["organ-jakub-password-hash"] {};

  users.users = {
    jakub = {
      hashedPasswordFile = config.age.secrets.organ-jakub-password-hash.path;
      openssh.authorizedKeys.keys = [config.sshPublicKey];
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
    };
  };

  programs.zsh.enable = true;
}
