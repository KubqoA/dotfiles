{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./aliases.nix
    ./fish.nix
    ./git.nix
    ./neovim
    ./xdg.nix
  ];

  home = {
    username = config.username;
    homeDirectory = config.homePath;

    packages = with pkgs; [home-manager];

    # Disable the Last login message in the terminal
    file.".hushlogin".text = "";
  };

  programs = {
    bat = {
      enable = true;
      config.theme = "base16";
    };
    fzf.enable = true;
    zoxide.enable = true;
  };

  home.stateVersion = "25.11";
}
