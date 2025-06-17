{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    jakub-password.neededForUsers = true;
    root-password.neededForUsers = true;
  };

  programs.zsh.enable = true;

  users.users = {
    ${config.username} = {
      hashedPasswordFile = config.sops.secrets.jakub-password.path;
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
    };

    root.hashedPasswordFile = config.sops.secrets.root-password.path;
  };
}
