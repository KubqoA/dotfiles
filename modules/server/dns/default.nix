# DNS master setup with dns.he.net as slave, with TSIG signed zone transfers,
# with automatic zone increments and dnssec signing, and multiple zone support.
#
# Usage:
#
# imports = lib._.moduleImports ["server/dns"]
# server.dns.zones."jakubarbet.me" = ./jakubarbet.me.zone;
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    server.dns.zones = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {};
      description = "An attribute set of zone names to zone files";
    };
  };

  config = {
    # Creates 3 activation scripts for each zone:
    # - dns-tsig-${zoneName} - generates TSIG key if it doesn't exist
    # - dns-dnssec-${zoneName} - generates DNSSEC key if it doesn't exist
    # - dns-zone-${zoneName} - increments zone serial, and signs the zone
    system.activationScripts = let
      mkActivationScripts = zoneName: zoneFile: {
        "dns-tsig-${zoneName}".text = ''
          mkdir -p /etc/named
          # Generate TSIG key if it doesn't exist
          if [ ! -f /etc/named/${zoneName}.tsig ]; then
            echo "[dns-tsig] Generating TSIG key for ${zoneName}:"
            ${pkgs.bind}/bin/tsig-keygen ${zoneName} > /etc/named/${zoneName}.tsig
            chmod 640 /etc/named/${zoneName}.tsig
            chown root:named /etc/named/${zoneName}.tsig
            cat /etc/named/${zoneName}.tsig
          fi
        '';
        "dns-dnssec-${zoneName}".text = ''
          mkdir -p /etc/named
          # Generate DNSSEC key if it doesn't exist
          if ! ls /etc/named/K${zoneName}*.key >/dev/null 2>/dev/null; then
            echo "[dns-dnssec] Generating DNSSEC key for ${zoneName}"
            ${pkgs.bind}/bin/dnssec-keygen -a NSEC3RSASHA1 -b 2048 -K /etc/named -n ZONE "${zoneName}" 2>/dev/null
            ${pkgs.bind}/bin/dnssec-keygen -f KSK -a NSEC3RSASHA1 -b 4096 -K /etc/named -n ZONE "${zoneName}"  2>/dev/null
          fi
        '';
        "dns-zone-${zoneName}" = {
          deps = ["dns-dnssec-${zoneName}"];
          text =
            builtins.replaceStrings
            ["cmp" "dnssec-signzone" "named-checkzone" "sed" "$ZONE_NAME" "$ZONE_FILE"]
            ["${pkgs.diffutils}/bin/cmp" "${pkgs.bind}/bin/dnssec-signzone" "${pkgs.bind}/bin/named-checkzone" "${pkgs.gnused}/bin/sed" "${zoneName}" "${zoneFile}"]
            (builtins.readFile ./increment-and-sign-zone.sh);
        };
      };
    in
      lib.mkMerge (
        lib.mapAttrsToList mkActivationScripts config.server.dns.zones
      );

    services.bind = {
      enable = true;
      listenOn = ["any"];
      listenOnIpv6 = ["!fe80::/64" "any"];
      extraConfig = lib.concatMapStrings (zoneName: ''
        include "/etc/named/${zoneName}.tsig";
      '') (builtins.attrNames config.server.dns.zones);
      extraOptions = ''
        dnssec-validation yes;
      '';
      zones = let
        mkZoneConfig = zoneName: zoneFile: {
          master = true;
          file = "/etc/named/${zoneName}.zone.signed";
          slaves = ["key ${zoneName}"];
          extraConfig = ''
            also-notify {
              216.218.130.2 key ${zoneName};
              2001:470:100::2 key ${zoneName};
            };
          '';
        };
      in
        lib.mapAttrs mkZoneConfig config.server.dns.zones;
    };

    networking.resolvconf.useLocalResolver = false;

    # Bind ports:
    # - 53 TCP/UDP for zone transfers
    networking.firewall.allowedTCPPorts = [53];
    networking.firewall.allowedUDPPorts = [53];
  };
}
