{
  config,
  pkgs,
  ...
}: {
  home = {
    username = config.username;
    homeDirectory = "/home/${config.username}";
    packages = with pkgs; [
      home-manager
      curl
      wget
      nurl
    ];
  };
}
