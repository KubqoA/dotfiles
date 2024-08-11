# [home-manager]
# git setup with gpg signing, assuming the gpg key is shared between machines

{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Jakub Arbet";
    userEmail = "hi@jakubarbet.me";
    signing = {
      key = "4EB39A80B52672EC";
      signByDefault = true;
    };
    ignores = [
      ".DS_Store"
      ".idea"
    ];
  };
}
