# [home-manager]
# git setup with gpg signing, assuming the gpg key is shared between machines
{
  config,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Jakub Arbet";
    userEmail = "hi@jakubarbet.me";
    signing = {
      key = config.gitSigningKey;
      signByDefault = lib.mkDefault true;
    };
    ignores = [
      ".DS_Store"
      ".idea"
    ];
    extraConfig.init.defaultBranch = "main";
  };
}
