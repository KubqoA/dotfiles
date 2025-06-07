# Default config to enable quadlet support
{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.quadlet-nix.nixosModules.quadlet];

  environment.persistence."/persist".directories = ["/var/lib/containers"];

  # Create quadlet user for running containers
  users = {
    users.quadlet = {
      uid = 999;
      isSystemUser = true;
      group = "quadlet";
    };
    groups.quadlet.gid = 999;
  };

  # Only quadlet services are using /mnt/storagebox, mount it under the quadlet user
  fileSystems."/mnt/storagebox".options = [
    "uid=${toString config.users.users.quadlet.uid}"
    "gid=${toString config.users.groups.quadlet.gid}"
  ];

  # Setup internal network for easier communication between containers
  virtualisation.quadlet.networks = {
    internal.networkConfig.driver = "bridge";
  };
}
