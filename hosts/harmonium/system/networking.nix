{
  config,
  pkgs,
  ...
}: {
  my.impermanence.directories = [
    "/var/lib/iwd"
  ];

  environment.systemPackages = with pkgs; [
    # TUI for iwd
    impala
  ];

  networking = {
    wireless.iwd = {
      enable = true;
      settings = {
        # Enable built-in DHCP client
        General.EnableNetworkConfiguration = true;

        # Automatically connect to known networks
        Settings.AutoConnect = true;
      };
    };

    networkmanager.enable = false;
  };

  users.users.${config.username}.extraGroups = ["network"];
}
