{
  config,
  pkgs,
  ...
}: {
  sops.secrets.jakub-password.neededForUsers = true;

  programs.fish.enable = true;

  users.users.${config.username} = {
    hashedPasswordFile = config.sops.secrets.jakub-password.path;
    openssh.authorizedKeys.keys = [config.sshPublicKey];
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.fish;
  };
}
