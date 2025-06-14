{
  config,
  pkgs,
  ...
}: let
  metricsPort = toString 9293;
in {
  # Prefer using quadlet-nix for services, but Docker is still needed for some
  # for example for Kamal (https://kamal-deploy.org/)
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    logDriver = "local";
    daemon.settings.metrics-addr = "127.0.0.1:${metricsPort}";
  };

  environment.systemPackages = [pkgs.docker-compose];

  users.users.${config.username}.extraGroups = ["docker"];

  # Docker Telemetry
  services.vector.settings = {
    sources.docker_metrics = {
      type = "prometheus_scrape";
      scrape_interval_secs = 15;
      endpoints = ["http://localhost:${metricsPort}/metrics"];
    };

    sinks.better_stack_http_metrics_sink.inputs = ["docker_metrics"];
  };
}
