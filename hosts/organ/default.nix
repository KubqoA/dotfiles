{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = lib.imports [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ./networking.nix
    ./storage.nix
    ./users.nix
    ./services/docker.nix
    ./services/mail.nix
    ./services/nginx.nix
    ./services/ssh.nix
    ./services/syncthing.nix
    "common/nix"
    "common/packages"
    "server/seafile"
    "server/tailscale"
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      seafile-password = {
        owner = config.services.seafile.user;
        mode = "0600";
      };
      tailscale-auth-key = {};
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = ["virtio_gpu"];
    kernelParams = ["console=tty"];
  };

  time.timeZone = "Europe/Prague";

  server = {
    seafile = {
      adminEmail = "hi@jakubarbet.me";
      adminPasswordFile = config.sops.secrets.seafile-password.path;
      dataDir = "/mnt/seafile/data";
    };
    tailscale = {
      tailnet = "ide-vega.ts.net";
      authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    };
  };

  system.stateVersion = "24.11";
}
