# [home-manager]
{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Jakub Arbet";
    userEmail = "hi@jakubarbet.me";
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    ignores = [
      ".DS_Store"
      ".idea"
      ".vscode"
      ".zed"
      ".cursor"
    ];
    extraConfig.init.defaultBranch = "main";
  };
}
