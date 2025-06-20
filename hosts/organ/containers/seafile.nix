{config, ...}: let
  # internalPort = toString 80;
  # servicePort = toString 9007;
  # inherit (config.virtualisation.quadlet) networks;
in {
  imports = [./base.nix];

  server.glance = {
    services.seafile = {
      url = "https://drive.${config.networking.domain}";
      # check-url = "http://seafile:${internalPort}";
    };
    releases = ["dockerhub:seafileltd/seafile-mc:12.0-latest"];
  };
}
