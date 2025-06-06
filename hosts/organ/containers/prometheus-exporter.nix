{inputs, ...}: {
  imports = [inputs.quadlet-nix.nixosModules.quadlet];

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
      publishPorts = ["127.0.0.1:9882:9882/tcp"];
      securityLabelDisable = true;
      autoUpdate = "registry";
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };
}
