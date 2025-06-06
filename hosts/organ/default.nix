{lib, ...}: {
  imports = lib.imports [
    ./containers/glance.nix
    ./containers/prometheus-exporter.nix
    ./betterstack.nix
    ./disko.nix
    ./hetzner.nix
    ./impermanence.nix
    ./networking.nix
    ./storagebox.nix
    ./users.nix
    # ./services/docker.nix
    # ./services/mail.nix
    # ./services/nginx.nix
    # ./services/syncthing.nix
    "common/packages"
    "server/defaults"
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };

  system.stateVersion = "25.05";
}
