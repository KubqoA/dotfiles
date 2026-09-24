{
  config,
  homes,
  inputs,
  lib,
  name,
  pkgs,
  self,
  system,
  ...
}: {
  imports = [
    inputs.sops-nix.darwinModules.sops
    ./homebrew.nix
    ./icons.nix
    ./nix.nix
    ./packages.nix
    ./settings.nix
  ];

  # Necessary here to set correct PATH, configuration managed by home-manager
  programs.fish.enable = true;

  # Declare the primary user and every user with a home-manager config on this host.
  # Set the knownUsers so that the default shell works
  # https://github.com/nix-darwin/nix-darwin/issues/1237#issuecomment-2562230471
  users = let
    toAccount = cfg: {inherit (cfg) username homePath uid;};
    accounts = lib.unique (map toAccount ([config] ++ map (home: home.config) homes));
  in {
    knownUsers = map (account: account.username) accounts;
    users =
      lib.mapToAttrs (account: {
        name = account.username;
        value = {
          home = account.homePath;
          shell = pkgs.fish;
          inherit (account) uid;
        };
      })
      accounts;
  };

  security = {
    # Add ability to use Touch ID for sudo
    pam.services.sudo_local = {
      reattach = true;
      touchIdAuth = true;
    };
    sudo.extraConfig = ''
      Defaults timestamp_timeout=5
    '';
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  # Use 1.1.1.1 as DNS resolver
  networking = {
    computerName = name;
    hostName = name;
    knownNetworkServices = ["Wi-Fi"];
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };

  # GitHub has their public key published
  # https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
  programs.ssh.knownHosts."github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    primaryUser = config.username;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ os changelog
    stateVersion = 4;

    # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
    activationScripts.postActivation.text = ''
      echo "activating settings..."
      sudo -u ${config.username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
}
