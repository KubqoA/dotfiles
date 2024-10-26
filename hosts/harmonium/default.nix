{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
      ./hardware-configuration.nix
    ]
    ++ lib._.moduleImports [
      "common/nix"
      "common/packages"
    ];

  hardware.enableAllFirmware = true;

  networking = {
    hostName = "harmonium"; # Define your hostname.
    networkmanager = {
      enable = true;
      # wifi.backend = "iwd";
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
        	["bluez5.enable-sbc-xq"] = true,
        	["bluez5.enable-msbc"] = true,
        	["bluez5.enable-hw-volume"] = true,
        	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '')
    ];
  };

  environment.systemPackages = with pkgs; [
    # For debugging and troubleshooting Secure Boot.
    sbctl
  ];

  programs.zsh.enable = true;
  programs.sway.enable = true;
  programs.light.enable = true;

  users.users.${config.username} = {
    # TODO: Research secret managers and use them to store the pass
    hashedPassword = "$6$rounds=500000$0rEHES1LTcVCJYz3$9MnsxPUjY2fcMKIHdlzZB0KW/52gPIpe9ENWcfpUlAIzG75rC3hDotfr44k7MwVVc6Ri0ePZB.q7G3xNbSvCx.";
    isNormalUser = true;
    extraGroups = ["audio" "video" "wheel" "networkmanager"];
    shell = pkgs.zsh;
  };

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

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
    enableTpm2 = true;
  };

  # Disables showing the generations menu, it can be still accessed when holding ‹spacebar› while booting
  # This makes the boot more "flicker free".
  boot.loader.timeout = 0;

  boot.plymouth.enable = true;

  # Darling erasure
  environment.etc = {
    nixos.source = "/persist/dotfiles";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    adjtime.source = "/persist/etc/adjtime";
    machine-id.source = "/persist/etc/machine-id";
    secureboot.source = "/persist/etc/secureboot";
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
  ];

  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a pristine state";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      # LUKS/TPM process
      "systemd-cryptsetup@enc.service"
    ];
    before = [
      "sysroot.mount"
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt

      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=/ /dev/mapper/enc /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines
      #
      # I suspect these are related to systemd-nspawn, but
      # since I don't use it I'm not 100% sure.
      # Anyhow, deleting these subvolumes hasn't resulted
      # in any issues so far, except for fairly
      # benign-looking errors from systemd-tmpfiles.
      btrfs subvolume list -o /mnt/root |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
      btrfs subvolume delete /mnt/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  users.users.root.hashedPassword = "$6$rounds=500000$0rEHES1LTcVCJYz3$9MnsxPUjY2fcMKIHdlzZB0KW/52gPIpe9ENWcfpUlAIzG75rC3hDotfr44k7MwVVc6Ri0ePZB.q7G3xNbSvCx.";

  security.polkit.enable = true;

  security.pam.services.hyprlock = {};

  system.stateVersion = "24.05";
}
