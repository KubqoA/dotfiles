{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.disko.nixosModules.disko];

  disko.devices.disk.main = {
    type = "disk";
    device = lib.mkDefault "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1M";
          end = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };
        root = {
          end = "-4G";
          content = {
            type = "btrfs";
            # Create blank root volume snapshot for impermanence
            postCreateHook = ''
              MNT_POINT=$(mktemp -d)
              mount /dev/disk/by-partlabel/disk-main-root "$MNT_POINT"
              btrfs subvolume snapshot -r $MNT_POINT/root $MNT_POINT/root-blank
              umount "$MNT_POINT"
              rm -rf "$MNT_POINT"
            '';
            subvolumes = {
              "/root" = {
                mountOptions = ["compress=zstd" "noatime"];
                mountpoint = "/";
              };
              "/home" = {
                mountOptions = ["compress=zstd" "noatime"];
                mountpoint = "/home";
              };
              "/persist" = {
                mountOptions = ["compress=zstd" "noatime"];
                mountpoint = "/persist";
              };
              "/nix" = {
                mountOptions = ["compress=zstd" "noatime"];
                mountpoint = "/nix";
              };
              "/log" = {
                mountOptions = ["compress=zstd" "noatime"];
                mountpoint = "/var/log";
              };
            };
          };
        };
        swap = {
          size = "100%";
          content.type = "swap";
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
}
