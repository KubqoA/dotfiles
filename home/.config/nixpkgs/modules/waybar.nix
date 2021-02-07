{ pkgs, ... }:

let
  buildScript = import ../buildScript.nix;
  battery = { name } : {
    bat = name;
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{capacity}% {icon}";
    format-charging = "{capacity}% ";
    format-plugged = "{capacity}% ";
    format-alt = "{time} {icon}";
    format-icons = [ "" "" "" "" "" ];
  };
  pango_escape_text = buildScript "pango_escape_text" ../config/waybar/pango_escape_text {
    python = "${(pkgs.python38.buildEnv.override {
      extraLibs = with pkgs.python38Packages; [ pygobject3 ];
    })}/bin/python";
  };
  mediaplayer = buildScript "mediaplayer" ../config/waybar/mediaplayer {
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    pango_escape_text = "${pango_escape_text}/bin/pango_escape_text";
  };
  play-pause = buildScript "play-pause" ../config/waybar/play-pause {
    playerctl = "${pkgs.playerctl}/bin/playerctl";
  };
  media = { number } : {
    format = "{icon} {}";
    return-type = "json";
    max-length = 55;
    format-icons = {
      Playing = "";
      Paused = "";
    };
    exec = "${mediaplayer}/bin/mediaplayer ${number}";
    exec-if = "[ $(${pkgs.playerctl}/bin/playerctl -l | wc -l) -ge ${number} ]";
    interval = 1;
    on-click = "${play-pause}/bin/play-pause ${number}";
  };
  nordvpn = buildScript "nordvpn" ../config/waybar/nordvpn {};
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.override { pulseSupport = true; };
    settings = [{
      height = 40;
      modules-left = [ "sway/workspaces" "sway/mode" "custom/media#1" "custom/media#2" ];
      modules-center = [];
      modules-right = [ "idle_inhibitor" "tray" "pulseaudio" "network" "custom/nordvpn" "memory" "cpu" "backlight" "battery#bat0" "battery#bat1" "clock" "custom/power" ];
      modules = {
        "sway/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "9" = "";
            "10" = "";
            focused = "";
            urgent = "";
            default = "";
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        tray = {
          spacing = 10;
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%A, %d %b}";
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{}% ";
        };
        backlight = {
          format = "{icon}";
          format-alt = "{percent}% {icon}";
          format-alt-click = "click-right";
          format-icons = [ "○" "◐" "●" ];
          on-scroll-down = "light -U 10";
          on-scroll-up = "light -A 10";
        };
        "battery#bat0" = battery { name = "BAT0"; };
        "battery#bat1" = battery { name = "BAT1"; };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "Ethernet ";
          format-linked = "Ethernet (No IP) ";
          format-disconnected = "Disconnected ";
          format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
          on-click-middle = "nm-connection-editor";
        };
        pulseaudio = {
          scroll-step = 1;
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        "custom/media#1" = media { number = "1"; };
        "custom/media#2" = media { number = "2"; };
        "custom/power" = {
      	  format = "";
      	  on-click = "nwgbar -o 0.2";
		  escape = true;
    	  tooltip = false;
        };
        "custom/nordvpn" = {
          format = "{}  ";
          return-type = "json";
          exec = "${nordvpn}/bin/nordvpn";
          interval = 10;
        };
      };
    }];
    style = builtins.readFile ../config/waybar/style.css;
  };
}
