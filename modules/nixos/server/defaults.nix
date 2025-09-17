# Adapted from https://github.com/nix-community/srvos
# Read through the options and picked parts I wanted as well
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.imports [
    "common/nix"
    "common/sudo"
    ./networking.nix
  ];

  boot = {
    # Use systemd during boot as well except:
    # - systems with raids as this currently require manual configuration: https://github.com/NixOS/nixpkgs/issues/210210
    # - for containers we currently rely on the `stage-2` init script that sets up our /etc
    initrd.systemd.enable = lib.mkDefault (!config.boot.swraid.enable && !config.boot.isContainer);

    # Given that our systems are headless, emergency mode is useless.
    # We prefer the system to attempt to continue booting so
    # that we can hopefully still access it remotely.
    initrd.systemd.suppressedUnits = lib.mkIf config.systemd.enableEmergencyMode [
      "emergency.service"
      "emergency.target"
    ];

    # Restrict the number of boot entries to prevent full /boot partition.
    loader.systemd-boot.configurationLimit = 10;

    # Ensure a clean & sparkling /tmp on fresh boots.
    tmp.cleanOnBoot = lib.mkDefault true;
  };

  environment = {
    systemPackages = with pkgs; [
      config.programs.git.package
      curl
      dnsutils
      htop
      jq
    ];

    # Don't install the /lib/ld-linux.so.2 stub. This saves one instance of nixpkgs.
    ldso32 = null;

    # Don't install the /lib/ld-linux.so.2 and /lib64/ld-linux-x86-64.so.2
    # stubs. Server users should know what they are doing.
    stub-ld.enable = lib.mkDefault false;
  };

  programs = {
    command-not-found.enable = lib.mkDefault false;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = false;
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      UseDns = false;
      # unbind gnupg sockets if they exists
      StreamLocalBindUnlink = true;

      # Use key exchange algorithms recommended by `nixpkgs#ssh-audit`
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
      ];
    };
  };

  systemd = {
    # Given that our systems are headless, emergency mode is useless.
    # We prefer the system to attempt to continue booting so
    # that we can hopefully still access it remotely.
    enableEmergencyMode = false;

    # For more detail, see:
    #   https://0pointer.de/blog/projects/watchdog.html
    watchdog = {
      # systemd will send a signal to the hardware watchdog at half
      # the interval defined here, so every 7.5s.
      # If the hardware watchdog does not get a signal for 15s,
      # it will forcefully reboot the system.
      runtimeTime = lib.mkDefault "15s";
      # Forcefully reboot if the final stage of the reboot
      # hangs without progress for more than 30s.
      # For more info, see:
      #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
      rebootTime = lib.mkDefault "30s";
      # Forcefully reboot when a host hangs after kexec.
      # This may be the case when the firmware does not support kexec.
      kexecTime = lib.mkDefault "1m";
    };

    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };

  # UTC everywhere
  time.timeZone = lib.mkDefault "UTC";

  users.mutableUsers = false;

  # Reduce bloat
  # No need for fonts on a server
  fonts.fontconfig.enable = lib.mkDefault false;

  # freedesktop xdg files
  xdg.autostart.enable = lib.mkDefault false;
  xdg.icons.enable = lib.mkDefault false;
  xdg.menus.enable = lib.mkDefault false;
  xdg.mime.enable = lib.mkDefault false;
  xdg.sounds.enable = lib.mkDefault false;
}
