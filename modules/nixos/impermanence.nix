{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options.impermanence = with lib; {
    rootPartition = mkOption {type = types.str;};
    serviceAfter = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    directories = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    files = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = {
    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = ["initrd.target"];
      before = ["sysroot.mount"];
      after = config.impermanence.serviceAfter;
      wants = config.impermanence.serviceAfter;
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";

      script = ''
        mkdir -p /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ ${config.impermanence.rootPartition} /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /root contains subvolumes:
        # - /root/var/lib/portables
        # - /root/var/lib/machines
        #
        # I suspect these are related to systemd-nspawn, but
        # since I don't use it I'm not 100% sure.
        # Anyhow, deleting these subvolumes hasn't resulted
        # in any issues so far, except for fairly
        # benign-looking errors from systemd-tmpfiles.
        btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };

    environment.persistence."/persist" = {
      directories =
        [
          "/var/lib/nixos" # needed to persist dynamically assigned uids/gids
        ]
        ++ config.impermanence.directories;
      files =
        [
          "/etc/machine-id"
          "/etc/adjtime"
        ]
        ++ config.impermanence.files;
    };
  };
}
