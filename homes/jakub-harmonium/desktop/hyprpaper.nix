{...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["${./bg.jpg}"];
      wallpaper = [", ${./bg.jpg}"];
    };
  };
}
