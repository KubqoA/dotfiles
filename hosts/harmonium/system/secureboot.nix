{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  environment.systemPackages = with pkgs; [
    # For debugging and troubleshooting Secure Boot.
    sbctl
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  # Enables support for secureboot, see:
  # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.initrd.systemd = {
    enable = true;
    # Required to support TPM-based unlocking of LUKS encrypted drives.
    # > sudo systemd-cryptenroll /dev/nvme0n1p6 --tpm2-device=auto --tpm2-pcrs=0+2+7
    # PCRs are important to guarantee tamper-proofing
    # Refer also to ./enable-tpm.sh
    tpm2.enable = true;
  };
}
