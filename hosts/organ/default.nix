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
      # ./mail.nix
      ./networking.nix
      # ./nginx.nix
      ./ssh.nix
      # ./syncthing.nix
      ./users.nix
    ]
    ++ lib._.moduleImports [
      "common/nix"
      "common/packages"
      "server/dns"
      "server/tailscale"
    ];

  age.secrets = lib._.defineSecrets ["organ-tailscale-auth-key"] {};

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
    tailscale = {
      tailnet = "ide-vega.ts.net";
      tailscaleIpv4 = "100.71.111.38";
      tailscaleIpv6 = "fd7a:115c:a1e0::2901:6f29";
      authKeyFile = config.age.secrets.organ-tailscale-auth-key.path;
    };
  };

  system.stateVersion = "24.11";
}
