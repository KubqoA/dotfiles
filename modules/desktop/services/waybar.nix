{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.services.waybar;
  audioSupport = config.modules.hardware.audio.enable;
  inherit (config.dotfiles) configDir binDir;
  inherit (lib._) hexColor rgbaColor colors buildBabashkaBinScript;
in {
  options.modules.desktop.services.waybar = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Some extra scripts for easier media support
    user.packages = with pkgs; mkIf audioSupport [
      pavucontrol
      playerctl
      (buildBabashkaBinScript "mediaplayer")
      (buildBabashkaBinScript "play-pause")
    ];

    home._.programs.waybar = let
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
      media = { number } : {
        format = "{icon} {}";
        return-type = "json";
        max-length = 55;
        format-icons = {
          Playing = "";
          Paused = "";
        };
        exec = "mediaplayer ${toString number}";
        exec-if = "[ $(playerctl -l 2>/dev/null | wc -l) -ge ${toString (number + 1)} ]";
        interval = 1;
        on-click = "play-pause ${toString number}";
      };
    in {
      enable = true;
      package = pkgs.waybar.override { pulseSupport = audioSupport; };
      settings = [{
        height = 40;
        modules-left = [ "sway/workspaces" "sway/mode" (mkIf audioSupport "custom/media#0") (mkIf audioSupport "custom/media#1") ];
        modules-center = [];
        modules-right = [ "tray" (mkIf audioSupport "pulseaudio") "network" "memory" "cpu" "backlight" "battery#bat0" "battery#bat1" "clock" "custom/power" ];
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
          pulseaudio = mkIf audioSupport {
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
          "custom/media#0" = mkIf audioSupport (media { number = 0; });
          "custom/media#1" = mkIf audioSupport (media { number = 1; });
          "custom/power" = {
            format = "";
            on-click = "nwgbar -o 0.2";
            escape = true;
            tooltip = false;
          };
        };
      }];
      style = let
        colorConfig = ''
          /* Colors */
          /* Base */
          #workspaces button,
          #mode,
          #tray,
          #pulseaudio,
          #network,
          #memory,
          #cpu,
          #backlight,
          #battery,
          #clock,
          #custom-media,
          #custom-power {
              background: ${rgbaColor colors.gray._200 90};
              color: ${hexColor colors.gray._700};
          }

          /* Effects */
          #workspaces button:hover {
              background: ${rgbaColor colors.gray._200 40};
          }

          #workspaces button.focused {
              background: ${rgbaColor colors.gray._300 100};
              color: ${hexColor colors.gray._800};
          }

          /* Disabled */
          #network.disconnected,
          #pulseaudio.muted,
          #custom-nordvpn.disconnected {
              background: ${rgbaColor colors.gray._200 50};
              color: ${hexColor colors.gray._400};
          }

          /* Green */
          #battery.charging {
              background: ${rgbaColor colors.green._200 60};
              color: ${hexColor colors.green._900};
          }

          /* Urgent */
          #workspaces button.urgent,
          #battery.critical:not(.charging) {
              background: ${rgbaColor colors.red._200 90};
              color: ${hexColor colors.red._900};
          }

          /* Tooltip */
          tooltip {
              background: ${rgbaColor colors.gray._200 90};
              box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
          }
          
          tooltip * {
              color: ${hexColor colors.gray._700};
          }
        '';
      in _.configWithExtras "${configDir}/waybar/style.css" colorConfig;
    };
  };
}
