{ config, lib, ... }:

with lib;
{
  options = {
    bind.zones = mkOption {
      type = with types; unique { message = "Duplicate DNS zone(s) defined"; } (attrsOf (submodule {
        options = {
      	  file = mkOpt { type = path; };
      	  extraConfig = mkOpt { type = str; default = ""; };
      	};
      }));
    };
  };

  config = mkIf config.services.bind.enable {
    networking.firewall.allowedUDPPorts = [ 53 ];
    networking.firewall.allowedTCPPorts = [ 53 ];

    services.bind = {
      extraConfig = ''
      acl he-slaves
      {
          216.218.133.2;    // slave.dns.he.net IPv4
          2001:470:600::2;  // slave.dns.he.net IPv6
      };
      '';

      extraOptions = ''
        dnssec-validation yes;
        also-notify
        {
            216.218.130.2; // ns1.he.net
        };
      '';

      zones = attrsets.mapAttrs (zone: conf: {
          file = builtins.toFile zone (builtins.readFile conf.file + "\n" + conf.extraConfig);
          master = true;
          slaves = [ "he-slaves" ];
          extraConfig = ''
            notify explicit;
            also-notify
            {
                216.218.130.2; // ns1.he.net
            };
          '';
      }) config.bind.zones;
    }; 
  };
}

