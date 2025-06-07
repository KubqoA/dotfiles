{
  config,
  lib,
  pkgs,
  ...
}: {
  sops.secrets.betterstack-env = {};

  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      sources = {
        host_metrics = {
          type = "host_metrics";
          scrape_interval_secs = 5;
          collectors = ["cpu" "disk" "filesystem" "load" "host" "memory" "network"];
          filesystem.mountpoints.includes = ["/" "/boot" "/mnt/storagebox"];
        };
        journald = {
          type = "journald";
        };
      };
      sinks = {
        better_stack_http_sink = {
          type = "http";
          method = "post";
          uri = "https://\${INGESTING_HOST}/";
          encoding = {
            codec = "json";
          };
          compression = "gzip";
          auth = {
            strategy = "bearer";
            token = "\${SOURCE_TOKEN}";
          };
          inputs = ["journald"];
        };
        better_stack_http_metrics_sink = {
          type = "http";
          method = "post";
          uri = "https://\${INGESTING_HOST}/metrics";
          encoding = {
            codec = "json";
          };
          compression = "gzip";
          auth = {
            strategy = "bearer";
            token = "\${SOURCE_TOKEN}";
          };
          inputs = ["host_metrics"];
        };
      };
    };
  };

  systemd.services.vector.serviceConfig = let
    cfg = config.services.vector;
    format = pkgs.formats.toml {};
    conf = format.generate "vector.toml" cfg.settings;
    # Overwrite the default vector setup to support env variables
    # when validating the conifg
    validateConfig = file:
      pkgs.runCommand "validate-vector-conf"
      {
        nativeBuildInputs = [cfg.package];
      }
      ''
        export INGESTING_HOST=example.com
        export SOURCE_TOKEN=foobar
        vector validate --no-environment "${file}"
        ln -s "${file}" "$out"
      '';
  in {
    ExecStart = lib.mkForce "${lib.getExe cfg.package} --config ${validateConfig conf}";
    EnvironmentFile = config.sops.secrets.betterstack-env.path;
  };
}
