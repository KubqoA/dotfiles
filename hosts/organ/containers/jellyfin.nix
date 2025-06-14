{config, ...}: let
  internalPort = toString 8096;
  servicePort = toString 9002;
  inherit (config.virtualisation.quadlet) networks;
in {
  imports = [./quadlet.nix];

  server.glance = {
    services.jellyfin = {
      url = "https://jellyfin.${config.networking.domain}";
      check-url = "http://jellyfin:${internalPort}";
    };
    releases = ["jellyfin/jellyfin"];
  };

  virtualisation.quadlet.containers.jellyfin = {
    containerConfig = {
      image = "docker.io/jellyfin/jellyfin:latest";
      name = "jellyfin";
      volumes = [
        "jellyfin-cache:/cache:Z"
        "jellyfin-config:/config:Z"
        "/mnt/storagebox/jellyfin:/media"
      ];
      networks = [networks.internal.ref];
      publishPorts = ["127.0.0.1:${servicePort}:${internalPort}/tcp"];
      autoUpdate = "registry";
      healthStartupCmd = "sleep 15";
      podmanArgs = ["--cpus=2"];
      user = toString config.users.users.quadlet.uid;
      group = toString config.users.groups.quadlet.gid;
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
      SuccessExitStatus = "0 143"; # Inform systemd of additional exit status
    };
  };

  services.nginx.virtualHosts."jellyfin.${config.networking.domain}" = {
    enableACME = true;
    forceSSL = true;
    extraConfig = ''
      # Security / XSS Mitigation Headers
      add_header X-Content-Type-Options "nosniff";

      # Permissions policy. May cause issues with some clients
      add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), battery=(), bluetooth=(), camera=(), clipboard-read=(), display-capture=(), document-domain=(), encrypted-media=(), gamepad=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), keyboard-map=(), local-fonts=(), magnetometer=(), microphone=(), payment=(), publickey-credentials-get=(), serial=(), sync-xhr=(), usb=(), xr-spatial-tracking=()" always;

      # Content Security Policy
      # See: https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
      # Enforces https content and restricts JS/CSS to origin
      # External Javascript (such as cast_sender.js for Chromecast) must be whitelisted.
      add_header Content-Security-Policy "default-src https: data: blob: ; img-src 'self' https://* ; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; script-src 'self' 'unsafe-inline' https://www.gstatic.com https://www.youtube.com blob:; worker-src 'self' blob:; connect-src 'self'; object-src 'none'; frame-ancestors 'self'; font-src 'self'";
    '';
    locations."/" = {
      proxyPass = "http://localhost:${servicePort}";
      recommendedProxySettings = true;
      extraConfig = ''
        # Disable buffering when the nginx proxy gets very resource heavy upon streaming
        proxy_buffering off;
      '';
    };
    locations."/socket" = {
      proxyPass = "http://localhost:${servicePort}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };

  services.vector.settings.sources.journald.exclude_units = ["jellyfin"];
}
