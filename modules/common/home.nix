# [home-manager]
{
  config,
  pkgs,
  ...
}: {
  home = {
    username = config.username;
    homeDirectory = config.homePath;

    packages = with pkgs; [home-manager];
  };
}
