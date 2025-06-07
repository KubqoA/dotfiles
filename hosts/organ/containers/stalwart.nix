{config, ...}: let
  servicePort = 9003;
  inherit (config.virtualisation.quadlet) networks;
in {
  imports = [./quadlet.nix];

  networking.firewall.allowedTCPPorts = [25 465 993 4190];

  virtualisation.quadlet.containers.stalwart = {
    containerConfig = {
      image = "docker.io/stalwartlabs/stalwart:latest";
      name = "stalwart";
      volumes = [
        # TODO: mount to /persist and have pre-defined config here
        # TODO: re-use acme cert from nginx virtual host
        "stalwart:/opt/stalwart:Z"
      ];
      networks = [networks.internal.ref];
      publishPorts = [
        "127.0.0.1:${toString servicePort}:8080/tcp"
        "25:25" # smtp
        "465:465" # smtps, recommended over starttls
        "993:993" # imaps
        "4190:4190" # managesieve
      ];
      autoUpdate = "registry";
      # user = toString config.users.users.quadlet.uid;
      # group = toString config.users.groups.quadlet.gid;
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
    locations."/".proxyPass = "http://localhost:${toString servicePort}/";
  };
}
