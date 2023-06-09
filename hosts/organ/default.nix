{ config, inputs, lib, modulesPath, ... }:

{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];

  boot.tmpOnTmpfs = false;

  networking.hostName = "organ";
  networking.domain = "jakubarbet.me";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  userName = "jakub";
  i18n.defaultLocale = "en_US.UTF-8";

  services.bind.enable = true;
  bind.zones = {
    "jakubarbet.me" = {
      file = ./jakubarbet.me.conf;
      extraConfig = ''
mail._domainkey	IN	TXT	( "v=DKIM1; k=rsa; "
	  "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDloXhkp6BjbbSe0tsDzVbbs0gaYpdTMJ4hG2Q25VLRXZpn9BdWD4Jtge8TwwjECjuiCsWdX284zptgX5lzze73Koq9CWjlrrKSpI+yn7RZON9GC+FDGgeuBQ2razhBtB6Zxwl3mNHnc9LQ/lfdOBad5OV36OldGiiUMs8Q4tmy/QIDAQAB" )  ; ----- DKIM key mail for jakubarbet.me
      '';
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "root@jakubarbet.me";
      webroot = "/var/lib/acme/acme-challenge";
    };
    certs."jakubarbet.me" = {
      domain = "jakubarbet.me";
      extraDomainNames = [
        "www.jakubarbet.me"
        "mail.jakubarbet.me"
        "autoconfig.jakubarbet.me"
        "autodiscover.jakubarbet.me"
        "drive.jakubarbet.me"
        "calendar.jakubarbet.me"
        "git.jakubarbet.me"
        "analyser.jakubarbet.me"
      ];
    };
  };

  services.nginx.enable = true;
}
