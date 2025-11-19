{lib, ...}: {
  imports = lib.imports [
    ./containers/glance.nix
    ./containers/immich.nix
    ./containers/jellyfin.nix
    ./containers/seafile.nix
    ./containers/stalwart.nix
    ./containers/syncthing.nix
    ./containers/prometheus-exporter.nix
    ./containers/vaultwarden.nix
    ./services/betterstack.nix
    ./services/docker.nix
    ./services/nginx.nix
    ./system/disko.nix
    ./system/storagebox.nix
    "nixos/base"
    "nixos/impermanence"
    "nixos/server"
    "nixos/hardware/hetzner"
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };

  my = {
    server = {
      domain = "jakubarbet.me";
      ipv4 = "49.13.218.47";
      ipv6 = "2a01:4f8:c013:d116::";
    };
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
  };
}
