# Default config to enable quadlet support
{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.quadlet-nix.nixosModules.quadlet];

  options.server.glance = with lib; let
    serviceOptions = {name, ...}: {
      options = {
        url = mkOption {type = types.str;};

        check-url = mkOption {
          type = types.nullOr types.str;
          default = null;
        };

        title = mkOption {
          type = types.str;
          default = capitalize name;
        };

        icon = mkOption {
          type = types.str;
          default = "si:${name}";
        };
      };
    };
  in {
    services = mkOption {
      type = types.attrsOf (types.submodule serviceOptions);
      default = {};
    };

    releases = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = {
    impermanence.directories = ["/var/lib/containers"];

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

    virtualisation.quadlet = {
      autoUpdate.enable = true;

      # Setup internal network for easier communication between containers
      networks.internal.networkConfig.driver = "bridge";
    };
  };
}
