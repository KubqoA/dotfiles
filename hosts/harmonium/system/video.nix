{
  config,
  pkgs,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.light.enable = true;

  # External monitors brightness control
  # See https://discourse.nixos.org/t/brightness-control-of-external-monitors-with-ddcci-backlight/8639/11
  boot.extraModulePackages = with config.boot.kernelPackages; [ddcci-driver];
  boot.initrd.kernelModules = ["ddcci_backlight"];
  environment.systemPackages = [pkgs.ddcutil];
  services.ddccontrol.enable = true;

  users.users.${config.username}.extraGroups = ["video"];
}
