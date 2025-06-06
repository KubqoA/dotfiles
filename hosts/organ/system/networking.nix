{...}: let
  ipv4 = "49.13.218.47";
  ipv6 = "2a01:4f8:c013:d116::";
in {
  networking = {
    domain = "jakubarbet.me";
    nameservers = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
  };

  # static ip configuration for hetzner cloud
  # https://docs.hetzner.com/cloud/servers/static-configuration/
  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp1s0";
      networkConfig.DHCP = "no";
      address = [
        "${ipv4}/32"
        "${ipv6}/64"
      ];
      routes = [
        {
          Gateway = "172.31.1.1";
          GatewayOnLink = true;
        }
        {Gateway = "fe80::1";}
      ];
    };
  };
}
