{...}: let
  servicePort = toString 9000;
  internalPort = toString 9882;
in {
  imports = [./quadlet.nix];

  server.glance.releases = ["containers/prometheus-podman-exporter"];

  virtualisation.quadlet.containers.prometheus-podman-exporter = {
    containerConfig = {
      image = "quay.io/navidys/prometheus-podman-exporter";
      name = "prometheus-podman-exporter";
      exec = "--collector.enable-all --collector.enhance-metrics --collector.store_labels";
      environments = {
        CONTAINER_HOST = "unix:///run/podman/podman.sock";
      };
      volumes = [
        "/run/podman/podman.sock:/run/podman/podman.sock"
      ];
      user = "root";
      publishPorts = ["127.0.0.1:${servicePort}:${internalPort}/tcp"];
      securityLabelDisable = true;
      autoUpdate = "registry";
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  services.vector.settings = {
    sources.podman_metrics = {
      type = "prometheus_scrape";
      scrape_interval_secs = 15;
      endpoints = ["http://localhost:${servicePort}/metrics"];
    };

    sinks.better_stack_http_metrics_sink.inputs = ["podman_metrics"];
  };
}
