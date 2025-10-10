{
  inputs,
  lib,
  ...
}: {
  imports = lib.imports [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
    ./system/audio.nix
    ./system/hardware-configuration.nix
    ./system/networking.nix
    ./system/plymouth.nix
    ./system/secureboot.nix
    ./system/users.nix
    ./system/video.nix
    ./ui.nix
    "nixos/nix"
    "nixos/packages"
    "nixos/sudo"
    "nixos/impermanence"
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/persist/sops-nix/key.txt";
  };

  impermanence = {
    rootPartition = "/dev/mapper/enc";
    serviceAfter = ["systemd-cryptsetup@enc.service"]; # run after LUKS
  };

  time.timeZone = "Europe/Prague";

  security.polkit.enable = true;

  boot.loader = {
    systemd-boot.configurationLimit = 3;
    efi.canTouchEfiVariables = true;
  };

  hardware.enableAllFirmware = true;

  system.stateVersion = "25.11";
}
