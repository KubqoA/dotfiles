{...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "hostmaster@jakubarbet.me";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."organ.jakubarbet.me" = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        proxy_intercept_errors on;
        error_page 401 /unauthorized.html;
      '';
      locations."/unauthorized.html" = {
        root = "/srv/www/organ.jakubarbet.me";
        extraConfig = "internal;";
      };
      locations."/syncthing/" = {
        extraConfig = "auth_request /auth;";
        proxyPass = "http://localhost:8384/";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
