# Some good defaults for Hetzner Cloud ARM VPS
# Inspired by https://github.com/nix-community/srvos/blob/main/nixos/hardware/hetzner-cloud/arm.nix
{
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = ["${modulesPath}/profiles/qemu-guest.nix"];

  boot = {
    loader = {
      # arm uses EFI, so we need systemd-boot
      systemd-boot.enable = true;
      # since it's a vm, we can do this on every update safely
      efi.canTouchEfiVariables = true;
    };

    # set console because the console defaults to serial and
    # initialize the display early to get a complete log.
    # this is required for typing in LUKS passwords on boot too.
    kernelParams = ["console=tty"];
    initrd.kernelModules = ["virtio_gpu"];
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;

    # Delegate the hostname setting to cloud-init by default
    hostName = lib.mkOverride 1337 ""; # lower prio than lib.mkDefault
  };

  services = {
    cloud-init = {
      enable = lib.mkDefault true;
      btrfs.enable = lib.mkDefault true;
      network.enable = lib.mkDefault true;

      # Never flush the host's SSH keys. See #148. Since we build the images
      # using NixOS, that kind of issue shouldn't happen to us.
      settings.ssh_deletekeys = lib.mkDefault false;
    };

    # Needed by the Hetzner Cloud password reset feature.
    qemuGuest.enable = lib.mkDefault true;
  };

  # https://discourse.nixos.org/t/qemu-guest-agent-on-hetzner-cloud-doesnt-work/8864/2
  systemd.services.qemu-guest-agent.path = [pkgs.shadow];
}
