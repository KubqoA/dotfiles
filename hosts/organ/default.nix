{lib, ...}: {
  imports = lib.imports [
    ./disko.nix
    ./hetzner.nix
    ./networking.nix
    # ./storage.nix
    ./users.nix
    # ./services/docker.nix
    # ./services/mail.nix
    # ./services/nginx.nix
    # ./services/syncthing.nix
    "common/packages"
    "server/defaults"
    # "server/seafile"
    # "server/tailscale"
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    # secrets = {
    #   seafile-password = {
    #     owner = config.services.seafile.user;
    #     mode = "0600";
    #   };
    #   tailscale-auth-key = {};
    # };
  };

  # server = {
  #   seafile = {
  #     adminEmail = "hi@jakubarbet.me";
  #     adminPasswordFile = config.sops.secrets.seafile-password.path;
  #     dataDir = "/mnt/seafile/data";
  #   };
  #   tailscale = {
  #     tailnet = "ide-vega.ts.net";
  #     authKeyFile = config.sops.secrets.tailscale-auth-key.path;
  #   };
  # };

  system.stateVersion = "25.05";
}
