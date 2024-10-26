{config, ...}: {
  services = {
    nginx.virtualHosts.${config.networking.fqdn}.locations."/syncthing/" = {
      extraConfig = "auth_request /auth;";
      proxyPass = "http://localhost:8384/";
    };
    syncthing = {
      enable = true;
      user = config.username;
      dataDir = "${config.users.users.${config.username}.home}/Sync";

      # https://docs.syncthing.net/users/config.html#config-option-gui.insecureskiphostcheck
      settings.gui.insecureSkipHostcheck = true;
    };
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
