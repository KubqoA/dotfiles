{
  pkgs,
  self,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      extra-platforms = aarch64-darwin
    '';
  };

  environment.variables = {EDITOR = "vim";};
  environment.shellAliases = {
    darwin-rebuild = "darwin-rebuild --flake ~/dotfiles";
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    wget
    (neovim.override {
      vimAlias = true;
    })
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.zsh.enable = true;

  environment.variables.HOMEBREW_NO_ANALYTICS = "1";

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    brews = [
      "asdf"
      "gpg"
      "gpg2"
      "pass"
      "pass-otp"
      "pinentry-mac"
      "sqlite"
    ];

    casks = [
      "arc"
      "beekeeper-studio"
      "figma"
      "iterm2"
      "loom"
      "notion"
      "obsidian"
      "orbstack"
      "raycast"
      "spotify"
      "unnaturalscrollwheels" # Enable natural scrolling in the trackpad but regular scroll on an external mouse
      "whatsapp"
      "zed"
    ];
  };

  users.users.jakub.home = "/Users/jakub";

  # Add ability to use Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
