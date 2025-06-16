{
  config,
  lib,
  pkgs,
  ...
}: let
  servicePort = toString 9001;
  internalPort = toString 8080;
  inherit (config.virtualisation.quadlet) networks;

  cfg = config.server.glance;
  settingsFormat = pkgs.formats.yaml {};
  servicesFile = settingsFormat.generate "services.yaml" [
    {
      type = "monitor";
      title = "Services";
      cache = "1m";
      sites = lib.mapAttrsToList (_: service: lib.compactAttrs service) cfg.services;
    }
  ];
  releasesFile = settingsFormat.generate "releases.yaml" [
    {
      type = "releases";
      show-source-icon = true;
      repositories = cfg.releases;
    }
  ];
in {
  imports = [./base.nix];

  sops.secrets.glance-env = {};

  server.glance.releases = ["glanceapp/glance"];

  virtualisation.quadlet.containers.glance = {
    containerConfig = {
      image = "docker.io/glanceapp/glance:latest";
      name = "glance";
      volumes = [
        "${./glance}:/app/config"
        "${servicesFile}:/app/config/services.yml"
        "${releasesFile}:/app/config/releases.yml"
        "/mnt/storagebox:/mnt/storagebox"
      ];
      environmentFiles = [config.sops.secrets.glance-env.path];
      networks = [networks.internal.ref];
      publishPorts = ["127.0.0.1:${servicePort}:${internalPort}"];
      autoUpdate = "registry";
      user = toString config.users.users.quadlet.uid;
      group = toString config.users.groups.quadlet.gid;
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  services.nginx.virtualHosts.${config.networking.fqdn} = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:${servicePort}/";
  };
}
