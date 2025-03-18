{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "hostmaster@${config.networking.domain}";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts.${config.networking.fqdn} = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        proxy_intercept_errors on;
        error_page 401 /unauthorized.html;
      '';
      locations."/unauthorized.html" = {
        root = "/srv/www/${config.networking.fqdn}";
        extraConfig = "internal;";
      };
    };
    virtualHosts."yoga.jakubarbet.me" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8080";
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
