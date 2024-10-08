{
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      ./git.nix
      ./hardware-configuration.nix
      ./mail.nix
      ./networking.nix
      ./nginx.nix
      ./tailscale.nix
    ]
    ++ lib._.moduleImports [
      "common/nix"
      "server/dns"
    ];

  server.dns.zones."jakubarbet.me" = ./jakubarbet.me.zone;

  age.secrets = lib._.defineSecrets ["organ-jakub-password-hash"] {};

  users.users = {
    jakub = {
      hashedPasswordFile = config.age.secrets.organ-jakub-password-hash.path;
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
      settings.PasswordAuthentication = false;
    };
    syncthing = {
      enable = true;
      relay.enable = true;
      user = "jakub";
      dataDir = "/home/jakub/Sync";
      # https://docs.syncthing.net/users/config.html#config-option-gui.insecureskiphostcheck
      settings.gui.insecureSkipHostcheck = true;
    };
  };

  # Syncthing ports:
  # - 22000 TCP and/or UDP for sync traffic
  # - 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall = {
    allowedTCPPorts =
      lib.optionals config.services.syncthing.enable [22000]
      ++ lib.optionals config.services.syncthing.relay.enable [
        config.services.syncthing.relay.port
        config.services.syncthing.relay.statusPort
      ];
    allowedUDPPorts = lib.optionals config.services.syncthing.enable [22000 21027];
  };

  time.timeZone = "Europe/Prague";

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
  system.stateVersion = "24.11"; # Did you read the comment?
}
