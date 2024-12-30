# [home-manager]
{
  config,
  pkgs,
  system,
  ...
}: {
  home = {
    username = config.username;
    homeDirectory =
      {
        x86_64-linux = "/home/${config.username}";
        aarch64-linux = "/home/${config.username}";
        aarch64-darwin = "/Users/${config.username}";
      }
      .${system};
    packages = with pkgs; [
      home-manager
      curl
      wget
      nurl
    ];
  };
}
