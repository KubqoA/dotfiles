{lib, ...}: {
  imports = lib.imports [
    ./containers/glance.nix
    ./disko.nix
    ./hetzner.nix
    ./impermanence.nix
    ./networking.nix
    # ./storage.nix
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

  # TODO: Remove - just temporary for testing things out
  #       Replace with proper reverse proxy setup
  networking.firewall.allowedTCPPorts = [80];

  system.stateVersion = "25.05";
}
