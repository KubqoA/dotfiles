{
  config,
  lib,
  pkgs,
  ...
}: let
  servicePort = toString 9001;
  internalPort = toString 8080;
  inherit (config.virtualisation.quadlet) networks;
in {
  imports = [./quadlet.nix];

  options.server.glance = with lib; let
    serviceOptions = {name, ...}: {
      options = {
        url = mkOption {
          type = types.str;
        };

        check-url = mkOption {
          type = types.nullOr types.str;
          default = null;
        };

        title = mkOption {
          type = types.str;
          default = capitalize name;
        };

        icon = mkOption {
          type = types.str;
          default = "si:${name}";
        };
      };
    };
  in {
    services = mkOption {
      type = types.attrsOf (types.submodule serviceOptions);
      default = {};
    };

    releases = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = let
    cfg = config.server.glance;
    settingsFormat = pkgs.formats.yaml {};
    servicesFile = settingsFormat.generate "services.yaml" [
      {
        type = "monitor";
        title = "Services";
        cache = "1m";
        sites = lib.mapAttrsToList (_: service: service) cfg.services;
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
    sops.secrets.glance-env = {};

    server.glance = {
      services = {
        immich.url = "https://photos.${config.networking.domain}";
        seafile.url = "https://drive.${config.networking.domain}";
      };
      releases = ["glanceapp/glance" "dockerhub:seafileltd/seafile-mc:12.0-latest" "immich-app/immich"];
    };

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
  };
}
