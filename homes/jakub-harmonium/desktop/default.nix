# Everything necessary to have a functioning desktop
{...}: {
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprbinds.nix

    # misc
    ./fonts.nix
    ./gtk.nix

    # apps and services
    ./swayosd.nix
    # TODO: status bar, notifications, output management, app menu, maybe widgets?
  ];
}
