# Tailscale setup for server with dnsmasq to provide custom DNS resolution
# for the tailnet, enabling NGINX Tailscale Auth protection for FQDN.
#
# DNS resolution is handled by dnsmasq and is configured to listen only on
# the tailscale IPs. Bind is configured to not listen on tailscale IPs.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.server.tailscale = {
    tailnet = mkOption {type = types.str;};
    authKeyFile = mkOption {type = types.path;};
  };

  config = {
    # Create runtime directory for dnsmasq dynamic config
    systemd.tmpfiles.rules = [
      "d /run/dnsmasq 0755 root root -"
    ];

    # Service to generate FQDN to tailscale IP mappings
    systemd.services.update-dnsmasq-config = {
      description = "Update dnsmasq configuration with Tailscale IPs";
      wantedBy = ["multi-user.target"];
      before = ["dnsmasq.service"];
      after = ["tailscaled.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "update-dnsmasq-config" ''
          set -euo pipefail

          # Get Tailscale IPs
          IPS=$(${pkgs.tailscale}/bin/tailscale ip)
          IPV4=$(echo "$IPS" | sed -n '1p')
          IPV6=$(echo "$IPS" | sed -n '2p')

          if [ -z "$IPV4" ] || [ -z "$IPV6" ]; then
            echo "Failed to get Tailscale IPs"
            exit 1
          fi

          # Create dnsmasq config
          echo "address=/${config.networking.fqdn}/$IPV4" >/run/dnsmasq/tailscale-addresses.conf
          echo "address=/${config.networking.fqdn}/$IPV6" >>/run/dnsmasq/tailscale-addresses.conf
        '';
      };
    };

    services = {
      # Let dnsmasq handle DNS resolution for the tailscale network
      bind = {
        extraConfig = ''
          acl tailscale {
            100.64.0.0/10;
            fd7a:115c:a1e0::/48;
          };
        '';
        listenOn = ["!tailscale"];
        listenOnIpv6 = ["!tailscale"];
      };

      # Used to define DNS override for FQDN to tailscale IPs so devices
      # connected to the tailnet can access the site which is behind
      # an tailscale-auth protection
      dnsmasq = {
        enable = true;
        resolveLocalQueries = false;
        settings = {
          no-hosts = true;
          bind-dynamic = true;
          interface = config.services.tailscale.interfaceName;
          no-dhcp-interface = config.services.tailscale.interfaceName;
          except-interface = "lo";
          conf-dir = "/run/dnsmasq";
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
        extraSetFlags = [
          "--ssh"
          "--advertise-exit-node" # offer to be exit node internet traffic for tailnet
          "--advertise-connector" # offer to be app connector for domain specific internet traffic for tailnet
        ];
        extraUpFlags = ["--ssh" "--advertise-exit-node" "--advertise-connector"];
      };
    };

    networking.firewall = {
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };
  };
}
