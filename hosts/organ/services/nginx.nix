{config, ...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "hostmaster@${config.networking.domain}";
  };

  environment.persistence."/persist".directories = ["/var/lib/acme"];

  networking.firewall.allowedTCPPorts = [80 443];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    statusPage = true;
  };

  services.vector.settings = {
    # TODO: Nginx logs forwarding

    sources.nginx_metrics = {
      type = "nginx_metrics";
      endpoints = ["http://localhost/nginx_status"];
    };

    sinks.better_stack_http_metrics_sink.inputs = ["nginx_metrics"];
  };
}
