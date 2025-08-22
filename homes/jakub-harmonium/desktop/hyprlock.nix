{...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        no_fade_in = true;
        disable_loading_bar = true;
      };

      background = [
        {
          monitor = "";
          path = "${./bg.jpg}";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "400, 50";
          outline_thickness = 0;

          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;

          outer_color = "rgba(255,255,255,0)";
          inner_color = "rgba(255,255,255,0.3)";
          check_color = "rgba(255,255,255,0.1)";
          font_color = "rgba(255,255,255,0.9)";

          font_family = "monospace";
          fail_color = "rgba(255,255,255,0.1)";
          fail_text = "$FAIL";
          fail_transition = 200;
          fail_timeout = 2000;

          hide_input = false;
          fade_on_empty = true;
          placeholder_text = "";

          position = "0, 60";
          halign = "center";
          valign = "bottom";
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<b>$(date +"%H:%M")</b>"'';
          color = "rgb(249,250,251)";
          font_size = 30;
          font_family = "monospace";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Welcome, $USER";
          color = "rgb(249,250,251)";
          font_size = 12;
          font_family = "monospace";
          position = "0, 30";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
