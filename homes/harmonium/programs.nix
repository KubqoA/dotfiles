{pkgs, ...}: {
  programs = {
    bat.enable = true;
    eza.enable = true;
    fd.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
  };

  services = {
    syncthing.enable = true;
  };

  home.packages = with pkgs; [
    chromium
    firefox
    obsidian
  ];
}
