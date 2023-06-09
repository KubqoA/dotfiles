{ config, lib, ... }:

with lib;
{
  options.nginx = {
  };

  config = mkIf config.services.nginx.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    users.users.nginx.extraGroups = [ "acme" ];

    services.nginx = {
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
  
      virtualHosts = let
        mkHost = domain: extraOptions: {
          name = domain;
          value = {
            forceSSL = true;
            useACMEHost = let
              domainParts = strings.splitString "." domain;
              acmeHostParts = lists.drop (length domainParts - 2) domainParts;
              acmeHost = strings.concatStringsSep "." acmeHostParts;
            in acmeHost;
            root = "/srv/www/${domain}/public_html";
          } // extraOptions;
        };
      in listToAttrs [
        (mkHost "jakubarbet.me" {
          default = true;
          serverAliases = [
            "www.jakubarbet.me"
            "autoconfig.jakubarbet.me"
            "autodiscover.jakubarbet.me"
            "analyser.jakubarbet.me"
          ];
        })
        (mkHost "mail.jakubarbet.me" {})
        (mkHost "drive.jakubarbet.me" {})
        (mkHost "calendar.jakubarbet.me" {})
        (mkHost "git.jakubarbet.me" {})
      ];
    };
  };
}

