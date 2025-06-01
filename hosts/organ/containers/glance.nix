{
  config,
  inputs,
  ...
}: {
  imports = [inputs.quadlet-nix.nixosModules.quadlet];

  sops.secrets.immich-api-key = {};

  virtualisation.quadlet.containers.glance = {
    containerConfig = {
      image = "glanceapp/glance:latest";
      name = "glance";
      volumes = [
        "${./glance}:/app/config"
        "${config.sops.secrets.immich-api-key.path}:/run/secrets/immich-api-key:ro"
        "/mnt/storagebox:/mnt/storagebox"
      ];
      publishPorts = ["80:8080"];
    };
    serviceConfig = {
      Restart = "always";
      RestartSec = "10s";
    };
  };
}
