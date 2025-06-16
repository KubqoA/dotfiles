{config, ...}: let
  # internalPort = toString 2283;
  # servicePort = toString 9006;
  # inherit (config.virtualisation.quadlet) networks;
in {
  imports = [./base.nix];

  server.glance = {
    services.immich = {
      url = "https://photos.${config.networking.domain}";
      # check-url = "http://immich:${internalPort}";
    };
    releases = ["immich-app/immich"];
  };
}
