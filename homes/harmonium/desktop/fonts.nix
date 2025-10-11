{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  home.packages = [pkgs.inter pkgs.nerd-fonts.jetbrains-mono];
}
