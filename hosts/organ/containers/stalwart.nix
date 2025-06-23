{config, ...}: let
  servicePort = toString 9003;
  internalPort = toString 8080;
  inherit (config.virtualisation.quadlet) networks;
in {
  imports = [./base.nix];

  server.glance = {
    services.stalwart = {
      url = "https://mail.${config.networking.domain}";
      check-url = "http://stalwart:${internalPort}";
      icon = "di:stalwart";
    };
    releases = ["stalwartlabs/stalwart"];
  };

  networking.firewall.allowedTCPPorts = [25 465 993 4190];

  virtualisation.quadlet.containers.stalwart = {
    containerConfig = {
      image = "docker.io/stalwartlabs/stalwart:v0.12";
      name = "stalwart";
      volumes = [
        # TODO: mount to /persist and have pre-defined config here
        # TODO: re-use acme cert from nginx virtual host
        "stalwart:/opt/stalwart:U"
      ];
      networks = [networks.internal.ref];
      publishPorts = [
        "127.0.0.1:${servicePort}:${internalPort}/tcp"
        "25:25" # smtp
        "465:465" # smtps, recommended over starttls
        "993:993" # imaps
        "4190:4190" # managesieve
      ];
      autoUpdate = "registry";
      user = toString config.users.users.quadlet.uid;
      group = toString config.users.groups.quadlet.gid;
      addCapabilities = ["NET_BIND_SERVICE"]; # Needed to bind to privileged ports (<1000)
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  services.nginx.virtualHosts."mail.${config.networking.domain}" = {
    serverAliases = [
      "mta-sts.${config.networking.domain}"
      "autoconfig.${config.networking.domain}"
      "autodiscover.${config.networking.domain}"
    ];
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:${servicePort}/";
  };
}
