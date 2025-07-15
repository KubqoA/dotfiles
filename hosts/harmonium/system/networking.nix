{
  config,
  pkgs,
  ...
}: {
  impermanence.directories = [
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

    nameservers = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];

    networkmanager.enable = false;
  };

  users.users.${config.username}.extraGroups = ["network"];
}
