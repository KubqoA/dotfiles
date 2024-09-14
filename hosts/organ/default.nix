{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  ipv4 = "116.203.250.61";
  ipv6 = "2a01:4f8:c012:58f4::";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  age.secrets = lib._.defineSecrets ["jakub-organ-password-hash"] {
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

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };
    bind = {
      enable = true;
      cacheNetworks = [
        "127.0.0.0/24"
        "::1/128"
      ];
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
    firewall.enable = true;
    # To allow zone transfers
    firewall.allowedTCPPorts = [53];
    firewall.allowedUDPPorts = [53];
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
