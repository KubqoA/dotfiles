{
  config,
  hostName,
  lib,
  options,
  pkgs,
  ...
}: let
  sopsEnabled = (builtins.tryEval (config.sops.defaultSopsFile != null)).value;
  wslGenerateResolvConf = options ? wsl && config.wsl.wslConf.network.generateResolvConf;
in {
  imports = [./nix.nix ./packages.nix];

  sops = lib.mkIf sopsEnabled {secrets."${config.username}-password".neededForUsers = true;};

  users.users.${config.username} = {
    # Only set password if sops is used in the host config
    hashedPasswordFile = lib.mkIf sopsEnabled config.sops.secrets."${config.username}-password".path;
    isNormalUser = true;
    extraGroups = ["wheel"];
    home = config.homePath;
    shell = pkgs.fish;
    uid = 1000;
  };

  programs.fish.enable = true;

  networking = {
    hostName = hostName;
    nameservers = lib.mkIf (!wslGenerateResolvConf) ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
  };

  security.sudo = {
    # Only allow members of the wheel group to execute sudo by setting the executable’s
    # permissions accordingly. This prevents users that are not members of wheel from
    # exploiting vulnerabilities in sudo such as CVE-2021-3156.
    execWheelOnly = true;

    # Don't lecture the user. Less mutable state.
    extraConfig = ''
      Defaults lecture = never
    '';

    wheelNeedsPassword = false;
  };

  system.stateVersion = "25.11";
}
