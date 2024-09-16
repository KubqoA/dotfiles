{
  config,
  lib,
  ...
}: let
  tailnet = "ide-vega.ts.net";
  tailscaleIpv4 = "100.67.2.27";
  tailscaleIpv6 = "fd7a:115c:a1e0::f101:21b";
in {
  age.secrets = lib._.defineSecrets ["organ-tailscale-auth-key"] {};

  services = {
    # Used to define DNS override for organ.jakubarbet.me to tailscale IPs
    # so devices connected to the tailnet can access the site which is behind
    # an tailscale-auth protection
    dnsmasq = {
      enable = true;
      settings = {
        bind-interfaces = true;
        listen-address = "${tailscaleIpv4},${tailscaleIpv6}";
        address = ["/organ.jakubarbet.me/${tailscaleIpv4}" "/organ.jakubarbet.me/${tailscaleIpv6}"];
      };
    };
    nginx.tailscaleAuth = {
      enable = true;
      expectedTailnet = tailnet;
      virtualHosts = ["organ.jakubarbet.me"];
    };
    tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.organ-tailscale-auth-key.path;
      useRoutingFeatures = "server";
      openFirewall = true;
      extraUpFlags = ["--advertiseTags tag:ssh"];
      extraSetFlags = [
        "--ssh"
        "--advertise-exit-node" # offer to be exit node internet traffic for tailnet
        "--advertise-connector" # offer to be app connector for domain specific internet traffic for tailnet
      ];
    };
  };

  networking.firewall = {
    # Don't firewall tailscale devices
    trustedInterfaces = lib.optionals config.services.tailscale.enable [config.services.tailscale.interfaceName];
  };
}
