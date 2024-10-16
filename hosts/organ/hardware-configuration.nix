# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  btrfsOptions = subvol: ["subvol=${subvol}" "compress=zstd" "noatime"];
in {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    kernelModules = [];
    extraModulePackages = [];
    kernelParams = ["console=tty"];
    initrd = {
      availableKernelModules = ["xhci_pci" "virtio_scsi" "sr_mod"];
      kernelModules = ["virtio_gpu"];
    };
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b927425d-7b67-4af5-95d5-1598b83e0001";
    fsType = "btrfs";
    options = btrfsOptions "root";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A5E5-1ED2";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b927425d-7b67-4af5-95d5-1598b83e0001";
    fsType = "btrfs";
    options = btrfsOptions "home";
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/b927425d-7b67-4af5-95d5-1598b83e0001";
    fsType = "btrfs";
    options = btrfsOptions "persist";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b927425d-7b67-4af5-95d5-1598b83e0001";
    fsType = "btrfs";
    options = btrfsOptions "nix";
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/b927425d-7b67-4af5-95d5-1598b83e0001";
    fsType = "btrfs";
    options = btrfsOptions "log";
    neededForBoot = true;
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/289ba3ad-decc-477a-8775-ccb4678e6a49";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
