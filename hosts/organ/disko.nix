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
          end = "128M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };
        root = {
          end = "-2G";
          content = {
            type = "btrfs";
            extraArgs = ["-f"]; # Override existing partition
            subvolumes = {
              "/root" = {
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
}
