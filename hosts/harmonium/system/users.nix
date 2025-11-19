{config, ...}: {
  sops.secrets.root-password.neededForUsers = true;

  users.users.root.hashedPasswordFile = config.sops.secrets.root-password.path;
}
