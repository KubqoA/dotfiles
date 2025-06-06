{lib, ...}: {
  imports = lib.imports [
    ./containers/glance.nix
    ./containers/jellyfin.nix
    ./containers/prometheus-exporter.nix
    ./services/betterstack.nix
    ./services/nginx.nix
    ./system/disko.nix
    ./system/hetzner.nix
    ./system/impermanence.nix
    ./system/networking.nix
    ./system/storagebox.nix
    ./system/users.nix
    "common/packages"
    "server/defaults"
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };

  system.stateVersion = "25.05";
}
