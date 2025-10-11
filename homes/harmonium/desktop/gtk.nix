{pkgs, ...}: {
  # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#fixing-problems-with-themes
  home.pointerCursor = {
    gtk.enable = true;
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
  };

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita";
    };

    iconTheme = {
      name = "Adwaita";
    };

    font = {
      name = "Inter";
      size = 11;
    };
  };
}
