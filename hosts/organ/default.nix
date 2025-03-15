{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = lib.imports [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ./docker.nix
    ./mail.nix
    ./networking.nix
    ./nginx.nix
    ./ssh.nix
    ./syncthing.nix
    ./users.nix
    "common/nix"
    "common/packages"
    "server/seafile"
    "server/tailscale"
  ];

  age.secrets = lib.defineSecrets {
    organ-tailscale-auth-key = {};
    organ-seafile-password = {
      owner = config.services.seafile.user;
      mode = "0600";
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
      adminPasswordFile = config.age.secrets.organ-seafile-password.path;
    };
    tailscale = {
      tailnet = "ide-vega.ts.net";
      authKeyFile = config.age.secrets.organ-tailscale-auth-key.path;
    };
  };

  system.stateVersion = "24.11";
}
