{config, ...}: let
  servicePort = 9001;
in {
  imports = [./quadlet.nix];

  sops.secrets.glance-env = {};

  virtualisation.quadlet.containers.glance = {
    containerConfig = {
      image = "docker.io/glanceapp/glance:latest";
      name = "glance";
      volumes = [
        "${./glance}:/app/config"
        "/mnt/storagebox:/mnt/storagebox"
      ];
      environmentFiles = [config.sops.secrets.glance-env.path];
      publishPorts = ["127.0.0.1:${toString servicePort}:8080"];
      autoUpdate = "registry";
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  services.nginx.virtualHosts.${config.networking.fqdn} = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:${toString servicePort}/";
  };
}
