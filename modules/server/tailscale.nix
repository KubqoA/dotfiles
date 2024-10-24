# Tailscale setup for server with dnsmasq to provide custom DNS resolution
# for the tailnet, enabling NGINX Tailscale Auth protection for FQDN.
#
# DNS resolution is handled by dnsmasq and is configured to listen only on
# the tailscale IPs. Bind is configured to not listen on tailscale IPs.
{
  config,
  lib,
  ...
}:
with lib; {
  options.server.tailscale = {
    tailnet = mkOption {type = types.str;};
    tailscaleIpv4 = mkOption {type = types.str;};
    tailscaleIpv6 = mkOption {type = types.str;};
    authKeyFile = mkOption {type = types.path;};
  };

  config = {
    services = {
      # Let dnsmasq handle DNS resolution for the tailscale network
      bind = {
        listenOn = ["!${config.server.tailscale.tailscaleIpv4}"];
        listenOnIpv6 = ["!${config.server.tailscale.tailscaleIpv6}"];
      };

      # Used to define DNS override for FQDN to tailscale IPs so devices
      # connected to the tailnet can access the site which is behind
      # an tailscale-auth protection
      dnsmasq = {
        enable = true;
        resolveLocalQueries = false;
        settings = {
          bind-interfaces = true;
          listen-address = "${config.server.tailscale.tailscaleIpv4},${config.server.tailscale.tailscaleIpv6}";
          address = ["/${config.networking.fqdn}/${config.server.tailscale.tailscaleIpv4}" "/${config.networking.fqdn}/${config.server.tailscale.tailscaleIpv6}"];
        };
      };

      nginx.tailscaleAuth = {
        enable = true;
        expectedTailnet = config.server.tailscale.tailnet;
        virtualHosts = [config.networking.fqdn];
      };

      tailscale = {
        enable = true;
        authKeyFile = config.server.tailscale.authKeyFile;
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
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };
  };
}
