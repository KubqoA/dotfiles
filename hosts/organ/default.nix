{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  ipv4 = "116.203.250.61";
  ipv6 = "2a01:4f8:c012:58f4::";
  tailnet = "ide-vega.ts.net";
  tailscaleIpv4 = "100.67.2.27";
  tailscaleIpv6 = "fd7a:115c:a1e0::f101:21b";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  age.secrets = lib._.defineSecrets ["jakub-organ-password-hash" "organ-tailscale-auth-key"] {
    "jakubarbet.me.key" = {owner = "named";};
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [config.sshPublicKey];
    jakub = {
      hashedPasswordFile = config.age.secrets.jakub-organ-password-hash.path;
      openssh.authorizedKeys.keys = [config.sshPublicKey];
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    neovim
  ];

  programs.zsh.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "hostmaster@jakubarbet.me";
  };

  services = {
    # Used to define DNS records for jakubarbet.me domain and
    # replicate them to dns.he.net servers
    bind = {
      enable = true;
      listenOn = ["127.0.0.1" "0.0.0.0"];
      listenOnIpv6 = ["::1" "::"];
      forwarders = config.networking.nameservers;
      extraConfig = ''
        include "${config.age.secrets."jakubarbet.me.key".path}";
      '';
      zones."jakubarbet.me" = {
        master = true;
        file = ./jakubarbet.me.conf;
        slaves = ["key jakubarbet.me"];
        extraConfig = ''
          also-notify {
            216.218.130.2 key jakubarbet.me;
            2001:470:100::2 key jakubarbet.me;
          };
        '';
      };
    };
    # Used to define DNS override for organ.jakubarbet.me to tailscale IPs
    # so devices connected to the tailnet can access the site which is behind
    # an tailscale-auth protection
    dnsmasq = {
      enable = true;
      settings = {
        bind-interfaces = true;
        listen-address = "${tailscaleIpv4},${tailscaleIpv6}";
        address = ["/organ.jakubarbet.me/${tailscaleIpv4}" "/organ.jakubarbet.me/${tailscaleIpv6}"];
      };
    };
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."organ.jakubarbet.me" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          proxy_intercept_errors on;
          error_page 401 /unauthorized.html;
        '';
        locations."/unauthorized.html" = {
          root = "/srv/www/organ.jakubarbet.me";
          extraConfig = "internal;";
        };
        locations."/syncthing/" = {
          extraConfig = "auth_request /auth;";
          proxyPass = "http://localhost:8384/";
        };
      };
      tailscaleAuth = {
        enable = true;
        expectedTailnet = tailnet;
        virtualHosts = ["organ.jakubarbet.me"];
      };
    };
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };
    syncthing = {
      enable = true;
      relay.enable = true;
      user = "jakub";
      dataDir = "/home/jakub/Sync";
      # https://docs.syncthing.net/users/config.html#config-option-gui.insecureskiphostcheck
      settings.gui.insecureSkipHostcheck = true;
    };
    tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.organ-tailscale-auth-key.path;
      useRoutingFeatures = "server";
      openFirewall = true;
      extraUpFlags = ["--advertiseTags tag:ssh"];
      extraSetFlags = [
        "--ssh"
        "--advertise-exit-node" # offer to be exit node internet traffic for tailnet
        "--advertise-connector" # offer to be app connector for domain specific internet traffic for tailnet
      ];
    };
  };

  # Bind ports:
  # - 53 TCP/UDP for zone transfers
  # Nginx ports
  # - 80 and 443 TCP
  # Syncthing ports:
  # - 22000 TCP and/or UDP for sync traffic
  # - 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall = {
    enable = true;
    trustedInterfaces = lib.optionals config.services.tailscale.enable [config.services.tailscale.interfaceName];
    allowedTCPPorts =
      []
      ++ lib.optionals config.services.bind.enable [53]
      ++ lib.optionals config.services.nginx.enable [80 443]
      ++ lib.optionals config.services.syncthing.enable [22000]
      ++ lib.optionals config.services.syncthing.relay.enable [
        config.services.syncthing.relay.port
        config.services.syncthing.relay.statusPort
      ];
    allowedUDPPorts =
      []
      ++ lib.optionals config.services.bind.enable [53]
      ++ lib.optionals config.services.syncthing.enable [22000 21027];
  };

  nix = {
    # Enable support for nix commands and flakes
    settings.experimental-features = ["nix-command" "flakes"];

    # Pinning the registry to the system pkgs on NixOS
    registry.nixpkgs.flake = inputs.nixpkgs;

    # Perform garbage collection weekly to maintain low disk usage
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    # Optimize storage
    # You can also manually optimize the store via:
    #    nix-store --optimise
    # Refer to the following link for more details:
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    settings.auto-optimise-store = true;
  };

  time.timeZone = "Europe/Prague";

  networking = {
    hostName = "organ";
    useDHCP = false;
    nameservers = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp1s0";
      networkConfig.DHCP = "no";
      address = [
        "${ipv4}/32"
        "${ipv6}/64"
      ];
      routes = [
        {
          Gateway = "172.31.1.1";
          GatewayOnLink = true;
        }
        {Gateway = "fe80::1";}
      ];
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
