{
  config,
  pkgs,
  ...
}: {
  sops.secrets.jakub-password.neededForUsers = true;

  programs.fish.enable = true;

  users.users.${config.username} = {
    hashedPasswordFile = config.sops.secrets.jakub-password.path;
    openssh.authorizedKeys.keys = config.sshPublicKeys;
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.fish;
  };
}
