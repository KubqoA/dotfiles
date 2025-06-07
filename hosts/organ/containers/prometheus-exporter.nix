{...}: let
  servicePort = 9000;
in {
  imports = [./quadlet.nix];

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
      publishPorts = ["127.0.0.1:${toString servicePort}:9882/tcp"];
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
      scrape_interval_secs = 5;
      endpoints = ["http://localhost:${toString servicePort}/metrics"];
    };

    sinks.better_stack_http_metrics_sink.inputs = ["podman_metrics"];
  };
}
