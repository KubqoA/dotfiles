{
  config,
  pkgs,
  ...
}: {
  # Enable Hyprland to enable all associated system configs
  # and configure Hyprland and associated userspace in home-manager
  programs.hyprland.enable = true;

  security.pam.services = {
    "autologin" = {
      startSession = true;
      allowNullPassword = true;
      showMotd = true;
      updateWtmp = true;
    };
    hyprlock = {};
  };

  environment.systemPackages = [pkgs.autologin];

  # Autologin to Hyprland → which launches hyprlock
  systemd.services.autologin = {
    description = "Autologin";

    wantedBy = ["multi-user.target"];
    conflicts = ["getty@tty1.service"];
    after = [
      "systemd-user-sessions.service"
      "plymouth-quit-wait.service"
      "getty@tty1.service"
    ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.autologin}/bin/autologin ${config.username} ${pkgs.hyprland}/bin/Hyprland";
      IgnoreSIGPIPE = false;
      SendSIGHUP = true;
      TimeoutStopSec = "30s";
      KeyringMode = "shared";
      Restart = "always";
      RestartSec = 1;
      StartLimitBurst = 5;
    };

    unitConfig = {
      StartLimitIntervalSec = 30;
    };
  };
}
