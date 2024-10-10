{
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      ./git.nix
      ./hardware-configuration.nix
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
    ];

  age.secrets = lib._.defineSecrets ["organ-tailscale-auth-key"] {};

  time.timeZone = "Europe/Prague";

  server = {
    dns.zones."jakubarbet.me" = ./dns/jakubarbet.me.zone;
    tailscale = {
      tailnet = "ide-vega.ts.net";
      tailscaleIpv4 = "100.67.2.27";
      tailscaleIpv6 = "fd7a:115c:a1e0::f101:21b";
      authKeyFile = config.age.secrets.organ-tailscale-auth-key.path;
    };
  };

  system.stateVersion = "24.11";
}
