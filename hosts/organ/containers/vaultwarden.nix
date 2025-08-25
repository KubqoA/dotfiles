{config, ...}: let
  vaultwardenVersion = "1.34.3";
  internalPort = toString 8080;
  servicePort = toString 9006;
  inherit (config.virtualisation.quadlet) networks;
in {
  imports = [./base.nix];

  sops.secrets.vaultwarden-env = {};

  server.glance = {
    services.vaultwarden = {
      url = "https://vaultwarden.${config.networking.domain}";
      check-url = "http://vaultwarden:${internalPort}";
    };
    releases = ["dani-garcia/vaultwarden"];
  };

  virtualisation.quadlet.containers.vaultwarden = {
    containerConfig = {
      image = "ghcr.io/dani-garcia/vaultwarden:${vaultwardenVersion}";
      name = "vaultwarden";
      volumes = [
        "/persist/data/vaultwarden:/data"
      ];
      environments = {
        PUSH_ENABLED = "true";
        PUSH_RELAY_URI = "https://api.bitwarden.eu";
        PUSH_IDENTITY_URI = "https://identity.bitwarden.eu";
        DOMAIN = "https://vaultwarden.${config.networking.domain}";
        SIGNUPS_ALLOWED = "false";
        ROCKET_PORT = "8080";
      };
      environmentFiles = [config.sops.secrets.vaultwarden-env.path];
      networks = [networks.internal.ref];
      publishPorts = [
        "127.0.0.1:${servicePort}:${internalPort}"
      ];
      autoUpdate = "registry";
      user = toString config.users.users.quadlet.uid;
      group = toString config.users.groups.quadlet.gid;
      healthCmd = "/healthcheck.sh";
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  services.nginx.virtualHosts."vaultwarden.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${servicePort}/";
      proxyWebsockets = true;
    };
  };
}
