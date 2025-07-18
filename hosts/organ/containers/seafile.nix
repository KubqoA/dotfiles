# Containers setup based on
# https://manual.seafile.com/12.0/repo/docker/ce/seafile-server.yml
# https://manual.seafile.com/12.0/repo/docker/notification-server.yml
{
  config,
  lib,
  ...
}: let
  internalPort = toString 80;
  servicePort = toString 9007;
  inherit (config.virtualisation.quadlet) containers networks pods;
in {
  imports = [./base.nix];

  sops.secrets.seafile-env = {};

  server.glance = {
    services.seafile = {
      url = "https://drive.${config.networking.domain}";
      check-url = "http://seafile:${internalPort}";
    };
    releases = ["dockerhub:seafileltd/seafile-mc:12.0-latest"];
  };

  virtualisation.quadlet = {
    pods.seafile = {
      podConfig = {
        networks = [networks.internal.ref];
        publishPorts = [
          "127.0.0.1:${servicePort}:${internalPort}"
        ];
      };
    };

    containers = let
      mkContainer = lib.recursiveUpdate {
        containerConfig = {
          pod = pods.seafile.ref;
          environments = rec {
            DB_HOST = "127.0.0.1";
            SEAFILE_MYSQL_DB_HOST = DB_HOST;
            TIME_ZONE = "Etc/UTC";
          };
          environmentFiles = [config.sops.secrets.seafile-env.path];
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
      seafile-seafile = mkContainer {
        containerConfig = {
          image = "docker.io/seafileltd/seafile-mc:12.0-latest";
          environments = {
            NON_ROOT = "true";
            SEAFILE_SERVER_HOSTNAME = "drive.jakubarbet.me";
            SEAFILE_SERVER_PROTOCOL = "https";
            ENABLE_SEADOC = "false";
          };
          volumes = [
            "/mnt/storagebox/seafile:/shared"
          ];
          user = "root";
          group = "root";
        };
        unitConfig = {
          Requires = [containers.seafile-mysql.ref containers.seafile-memcached.ref]; # containers.seafile-seasearch.ref];
          After = [containers.seafile-mysql.ref containers.seafile-memcached.ref]; # containers.seafile-seasearch.ref];
        };
      };

      seafile-mysql = mkContainer {
        containerConfig = {
          image = "docker.io/mariadb:10.11";
          environments = {
            MYSQL_LOG_CONSOLE = "true";
            MARIADB_AUTO_UPGRADE = "1";
          };
          volumes = ["seafile-mysql:/var/lib/mysql:U"];
          healthCmd = "/usr/local/bin/healthcheck.sh --connect --mariadbupgrade --innodb_initialized";
          healthInterval = "20s";
          healthStartPeriod = "30s";
          healthTimeout = "10s";
          healthRetries = 10;
        };
      };

      seafile-memcached = mkContainer {
        containerConfig = {
          name = "memcached"; # seafile hard-coded memcached as the host, this will be fixed in 13.0
          image = "docker.io/memcached:1.6.29";
          exec = "-m 256";
        };
      };

      # seafile-notification-server = mkContainer {
      #   containerConfig = {
      #     image = "docker.io/seafileltd/notification-server:12.0-latest";
      #     volumes = [
      #       "seafile-notification-server:/shared:U"
      #       "seafile-notification-server-logs:/shared/logs:U"
      #     ];
      #   };
      #   unitConfig = {
      #     Requires = [containers.seafile-mysql.ref containers.seafile-seafile.ref];
      #     After = [containers.seafile-mysql.ref containers.seafile-seafile.ref];
      #   };
      # };
    };
  };

  services.nginx.virtualHosts."drive.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${servicePort}/";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 0;
        proxy_read_timeout   310s;
      '';
    };
  };
}
