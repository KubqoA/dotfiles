{config, ...}: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    logDriver = "none";
  };

  users.users.${config.username}.extraGroups = ["docker"];
}
