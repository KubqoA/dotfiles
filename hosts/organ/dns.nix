{
  config,
  lib,
  pkgs,
  ...
}: let
  ipv4 = "116.203.250.61";
  ipv6 = "2a01:4f8:c012:58f4::";
in {
  age.secrets = lib._.defineSecrets [] {
    "organ-jakubarbetme-tsig" = {owner = "named";};
  };

  system.activationScripts.increment-and-sign-zone.text =
    builtins.replaceStrings
    ["cmp" "dnssec-keygen" "dnssec-signzone" "named-checkzone" "sed" "./jakubarbet.me.conf"]
    ["${pkgs.diffutils}/bin/cmp" "${pkgs.bind}/bin/dnssec-signzone" "${pkgs.bind}/bin/dnssec-keygen" "${pkgs.bind}/bin/named-checkzone" "${pkgs.gnused}/bin/sed" "${./jakubarbet.me.conf}"]
    (builtins.readFile ./increment-and-sign-zone.sh);

  # Used to define DNS records for jakubarbet.me domain and
  # replicate them to dns.he.net servers
  services.bind = {
    enable = true;
    listenOn = ["any"];
    listenOnIpv6 = ["any"];
    extraConfig = ''
      include "${config.age.secrets.organ-jakubarbetme-tsig.path}";
    '';
    extraOptions = ''
      dnssec-validation yes;
    '';
    zones."jakubarbet.me" = {
      master = true;
      file = "/etc/named/jakubarbet.me.conf.signed";
      slaves = ["key jakubarbet.me"];
      extraConfig = ''
        also-notify {
          216.218.130.2 key jakubarbet.me;
          2001:470:100::2 key jakubarbet.me;
        };
      '';
    };
  };

  # Bind ports:
  # - 53 TCP/UDP for zone transfers
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
}
