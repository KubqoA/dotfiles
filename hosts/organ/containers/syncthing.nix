{config, ...}: let
  servicePort = 9004;
  inherit (config.virtualisation.quadlet) networks;
in {
  imports = [./quadlet.nix];

  virtualisation.quadlet.containers.syncthing = {
    containerConfig = {
      image = "docker.io/syncthing/syncthing:latest";
      name = "syncthing";
      volumes = [
        # TODO: Move /mnt/storagebox/syncthing/config -> /persist
        #       And define the configuration via Nix
        "/mnt/storagebox/syncthing:/var/syncthing"
      ];
      environments = {
        PUID = toString config.users.users.quadlet.uid;
        PGID = toString config.users.groups.quadlet.gid;
      };
      networks = [networks.internal.ref];
      publishPorts = [
        "127.0.0.1:${toString servicePort}:8384"
        "22000:22000/tcp"
        "22000:22000/udp"
        "21027:21027/udp"
      ];
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
    locations."/syncthing/".proxyPass = "http://localhost:${toString servicePort}/";
  };

  # Syncthing ports:
  # - 22000 TCP and/or UDP for sync traffic
  # - 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall = {
    allowedTCPPorts = [22000];
    allowedUDPPorts = [22000 21027];
  };
}
