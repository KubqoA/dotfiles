{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  host = "drive.${config.networking.domain}";
  cfg = config.services.seafile;
  seafRoot = "/var/lib/seafile";
  seahubDir = "${seafRoot}/seahub";
in {
  options.server.seafile = {
    adminEmail = mkOption {type = types.str;};
    adminPasswordFile = mkOption {type = types.path;};
    dataDir = mkOption {
      type = types.path;
      default = "${seafRoot}/data";
    };
  };

  config = {
    services = {
      nginx.virtualHosts.${host} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://unix:/run/seahub/gunicorn.sock";
        locations."/seafhttp" = {
          proxyPass = "http://unix:/run/seafile/server.sock";
          extraConfig = ''
            rewrite ^/seafhttp(.*)$ $1 break;
            client_max_body_size 0;
            proxy_connect_timeout  36000s;
            proxy_read_timeout  36000s;
            proxy_send_timeout  36000s;
            send_timeout  36000s;
            proxy_http_version 1.1;
          '';
        };
        locations."/media".root = seahubDir;
      };
      seafile = {
        enable = true;
        ccnetSettings.General.SERVICE_URL = "https://${host}";
        seafileSettings.fileserver.host = "unix:/run/seafile/server.sock";
        adminEmail = config.server.seafile.adminEmail;
        initialAdminPassword = "whatever"; # overriden below
        seahubExtraConf = ''
          CSRF_TRUSTED_ORIGINS = ["https://${host}"]
        '';
        dataDir = config.server.seafile.dataDir;
      };
    };

    # Override of this preStart to support setting the seafile admin password from file
    systemd.services.seahub.preStart = lib.mkForce ''
      mkdir -p ${seahubDir}/media
      # Link all media except avatars
      for m in `find ${cfg.seahubPackage}/media/ -maxdepth 1 -not -name "avatars"`; do
        ln -sf $m ${seahubDir}/media/
      done
      if [ ! -e "${seafRoot}/.seahubSecret" ]; then
          (
            umask 377 &&
            ${lib.getExe cfg.seahubPackage.python3} ${cfg.seahubPackage}/tools/secret_key_generator.py > ${seafRoot}/.seahubSecret
          )
      fi
      if [ ! -f "${seafRoot}/seahub-setup" ]; then
          # avatars directory should be writable
          install -D -t ${seahubDir}/media/avatars/ ${cfg.seahubPackage}/media/avatars/default.png
          install -D -t ${seahubDir}/media/avatars/groups ${cfg.seahubPackage}/media/avatars/groups/default.png
          # init database
          ${cfg.seahubPackage}/manage.py migrate
          # create admin account
          ${lib.getExe pkgs.expect} -c 'spawn ${cfg.seahubPackage}/manage.py createsuperuser --email=${cfg.adminEmail}; expect "Password: "; send [exec cat ${config.server.seafile.adminPasswordFile}]\r; expect "Password (again): "; send [exec cat ${config.server.seafile.adminPasswordFile}]\r; expect "Superuser created successfully."'
          echo "${cfg.seahubPackage.version}-mysql" > "${seafRoot}/seahub-setup"
      fi
      if [ $(cat "${seafRoot}/seahub-setup" | cut -d"-" -f1) != "${pkgs.seahub.version}" ]; then
          # run django migrations
          ${cfg.seahubPackage}/manage.py migrate
          echo "${cfg.seahubPackage.version}-mysql" > "${seafRoot}/seahub-setup"
      fi
    '';
  };
}
