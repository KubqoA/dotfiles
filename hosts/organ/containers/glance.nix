{config, ...}: {
  imports = [./quadlet.nix];

  sops.secrets.glance-env = {};

  virtualisation.quadlet.containers.glance = {
    containerConfig = {
      image = "glanceapp/glance:latest";
      name = "glance";
      volumes = [
        "${./glance}:/app/config"
        "/mnt/storagebox:/mnt/storagebox"
      ];
      environmentFiles = [config.sops.secrets.glance-env.path];
      publishPorts = ["127.0.0.1:8080:8080"];
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  services.nginx.virtualHosts.${config.networking.fqdn} = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:8080/";
  };
}
