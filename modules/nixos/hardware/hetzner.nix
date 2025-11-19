{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: let
  cfg = config.my.server;
in {
  imports = ["${modulesPath}/profiles/qemu-guest.nix"];

  options.my.server = with lib; {
    ipv4 = mkOption {type = types.str;};
    ipv6 = mkOption {type = types.str;};
  };

  config = {
    # good defaults for Hetzner Cloud ARM, inspired by
    # https://github.com/nix-community/srvos/blob/main/nixos/hardware/hetzner-cloud/arm.nix

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

    # static IP config
    # https://docs.hetzner.com/cloud/servers/static-configuration/
    # https://wiki.nixos.org/wiki/Install_NixOS_on_Hetzner_Cloud#Static_IPv4_configuration
    systemd.network.networks."30-wan" = {
      matchConfig.Name = "enp1s0";
      networkConfig.DHCP = "no";
      address = ["${cfg.ipv4}/32" "${cfg.ipv6}/64"];
      routes = [
        {
          Gateway = "172.31.1.1";
          GatewayOnLink = true;
        }
        {Gateway = "fe80::1";}
      ];
    };
  };
}
