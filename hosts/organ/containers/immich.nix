{config, ...}: let
  internalPort = toString 2283;
  servicePort = toString 9005;
  inherit (config.virtualisation.quadlet) networks;
in {
  imports = [./base.nix];

  sops.secrets.immich-env = {};

  server.glance = {
    services.immich = {
      url = "https://photos.${config.networking.domain}";
      check-url = "http://immich-server:${internalPort}";
    };
    releases = ["immich-app/immich"];
  };

  virtualisation.quadlet.containers = {
    immich-server = {
      unitConfig = {
        Requires = "immich-redis.service immich-postgres.service";
      };
      containerConfig = {
        image = "ghcr.io/immich-app/immich-server:release";
        name = "immich-server";
        volumes = [
          "/mnt/storagebox/immich:/usr/src/app/upload"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environmentFiles = [config.sops.secrets.immich-env.path (toString ./immich/.env)];
        environments = {
          REDIS_HOSTNAME = "immich-redis";
          DB_HOSTNAME = "immich-postgres";
        };
        networks = [networks.internal.ref];
        publishPorts = [
          "127.0.0.1:${servicePort}:${internalPort}"
        ];
        autoUpdate = "registry";
        user = toString config.users.users.quadlet.uid;
        group = toString config.users.groups.quadlet.gid;
      };
      serviceConfig = {
        Restart = "always";
      };
    };

    immich-machine-learning = {
      containerConfig = {
        image = "ghcr.io/immich-app/immich-machine-learning:release";
        name = "immich-machine-learning";
        environmentFiles = [config.sops.secrets.immich-env.path (toString ./immich/.env)];
        volumes = [
          "immich-model-cache:/cache"
        ];
        networks = [networks.internal.ref];
        podmanArgs = ["--cpus=2"];
      };
      serviceConfig = {
        Restart = "always";
      };
    };

    immich-redis = {
      containerConfig = {
        image = "docker.io/valkey/valkey:8-bookworm@sha256:fec42f399876eb6faf9e008570597741c87ff7662a54185593e74b09ce83d177";
        name = "immich-redis";
        environmentFiles = [config.sops.secrets.immich-env.path (toString ./immich/.env)];
        networks = [networks.internal.ref];
      };
      serviceConfig = {
        Restart = "always";
      };
    };

    immich-postgres = {
      containerConfig = {
        image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.2-pgvectors0.2.0";
        name = "immich-postgres";
        environmentFiles = [config.sops.secrets.immich-env.path (toString ./immich/.env)];
        environments = {
          POSTGRES_INITDB_ARGS = "'--data-checksums'";
        };
        volumes = [
          "immich-postgres:/var/lib/postgresql/data"
        ];
        networks = [networks.internal.ref];
      };
      serviceConfig = {
        Restart = "always";
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
