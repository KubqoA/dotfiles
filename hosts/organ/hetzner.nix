# Some good defaults for Hetzner Cloud ARM VPS
# Inspired by https://github.com/nix-community/srvos/blob/main/nixos/hardware/hetzner-cloud/arm.nix
{
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
  };

  # Needed by the Hetzner Cloud password reset feature.
  services.qemuGuest.enable = true;

  # https://discourse.nixos.org/t/qemu-guest-agent-on-hetzner-cloud-doesnt-work/8864/2
  systemd.services.qemu-guest-agent.path = [pkgs.shadow];
}
