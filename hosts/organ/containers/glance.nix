{config, ...}: {
  imports = [./quadlet.nix];

  sops.secrets.glance-env = {};

  # TODO: Remove - just temporary for testing things out
  #       Replace with proper reverse proxy setup
  networking.firewall.allowedTCPPorts = [80];

  virtualisation.quadlet.containers.glance = {
    containerConfig = {
      image = "glanceapp/glance:latest";
      name = "glance";
      volumes = [
        "${./glance}:/app/config"
        "/mnt/storagebox:/mnt/storagebox"
      ];
      environmentFiles = [config.sops.secrets.glance-env.path];
      publishPorts = ["80:8080"];
    };
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };
}
