{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
      ./disko.nix
      # ./git.nix
      ./mail.nix
      ./networking.nix
      ./nginx.nix
      ./ssh.nix
      ./syncthing.nix
      ./users.nix
    ]
    ++ lib._.moduleImports [
      "common/nix"
      "common/packages"
      "server/dns"
      "server/seafile"
      "server/tailscale"
    ];

  age.secrets = lib._.defineSecrets ["organ-tailscale-auth-key"] {
    "organ-seafile-password" = {
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
    dns.zones."jakubarbet.me" = ./dns/jakubarbet.me.zone;
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
