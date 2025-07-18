{
  config,
  lib,
  ...
}: let
  immichVersion = "v1.135.3";
  internalPort = toString 2283;
  servicePort = toString 9005;
  inherit (config.virtualisation.quadlet) networks pods;
in {
  imports = [./base.nix];

  sops.secrets.immich-env = {};

  server.glance = {
    services.immich = {
      url = "https://photos.${config.networking.domain}";
      check-url = "http://immich:${internalPort}";
    };
    releases = ["immich-app/immich"];
  };

  virtualisation.quadlet = {
    pods.immich = {
      podConfig = {
        networks = [networks.internal.ref];
        podmanArgs = ["--cpus=2"];
        publishPorts = [
          "127.0.0.1:${servicePort}:${internalPort}"
        ];
      };
    };

    containers = let
      mkContainer = lib.recursiveUpdate {
        containerConfig = {
          pod = pods.immich.ref;
          environments = {
            TZ = "Europe/Prague";
            DB_USERNAME = "postgres";
            DB_DATABASE_NAME = "immich";
          };
          environmentFiles = [config.sops.secrets.immich-env.path];
          autoUpdate = "registry";
          user = toString config.users.users.quadlet.uid;
          group = toString config.users.groups.quadlet.gid;
        };
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = "30s";
        };
      };
    in {
      immich-server = mkContainer {
        unitConfig = {
          Requires = "immich-redis.service immich-postgres.service";
        };
        containerConfig = {
          image = "ghcr.io/immich-app/immich-server:${immichVersion}";
          environments = {
            REDIS_HOSTNAME = "localhost";
            DB_HOSTNAME = "localhost";
          };
          volumes = [
            "/mnt/storagebox/immich:/usr/src/app/upload"
            "/etc/localtime:/etc/localtime:ro"
          ];
          healthCmd = "curl -L 'localhost:2283/api/server/ping' -H 'Accept: application/json'";
        };
      };

      immich-machine-learning = mkContainer {
        containerConfig = {
          image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";
          volumes = ["immich-model-cache:/cache:U"];
        };
      };

      immich-redis = mkContainer {
        containerConfig = {
          image = "docker.io/valkey/valkey:8-bookworm@sha256:fec42f399876eb6faf9e008570597741c87ff7662a54185593e74b09ce83d177";
          volumes = ["immich-redis:/data:U"];
          healthCmd = "redis-cli ping || exit 1";
        };
      };

      immich-postgres = mkContainer {
        containerConfig = {
          image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0";
          environments.POSTGRES_INITDB_ARGS = "'--data-checksums'";
          volumes = ["immich-postgres:/var/lib/postgresql/data:U"];
          healthCmd = "pg_isready -h localhost -p 5432 || exit 1";
        };
      };
    };
  };

  services.nginx.virtualHosts."photos.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${servicePort}/";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout   600s;
        proxy_send_timeout   600s;
        send_timeout         600s;
      '';
    };
  };
}
