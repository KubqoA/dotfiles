{lib, ...}: {
  imports = lib.imports ["nixos/impermanence"];

  impermanence = {
    rootPartition = "/dev/disk/by-partlabel/disk-main-root";
    serviceAfter = ["systemd-udev-settle.service"]; # makes sure /dev/disk/by-partlabel is ready
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
