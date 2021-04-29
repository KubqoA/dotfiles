{ pkgs, ... }:

let
  spicetify = fetchTarball https://github.com/pietdevries94/spicetify-nix/archive/master.tar.gz;
in
{
  imports = [ (import "${spicetify}/module.nix") ];

  home.packages = with pkgs; [ imv transmission-gtk ];

  programs.mpv = {
    enable = true;
    package = pkgs.wrapMpv (pkgs.mpv-unwrapped.override) { scripts = [ pkgs.mpvScripts.mpris ]; };
    bindings = {
      "ALT+k" = "add sub-scale +0.1";
      "ALT+j" = "add sub-scale -0.1";
      "ALT+=" = "add video-zoom +0.1";
      "ALT+-" = "add video-zoom -0.1";
    };
    config = {
      profile = "gpu-hq";
      hwdec = "auto-safe";
      vo = "gpu";
      gpu-context = "wayland";
      save-position-on-quit = true;
      ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
    };
  };

  home.file.".config/PulseEffects/output/WH-1000XM3.json".source = ../config/PulseEffects/WH-1000XM3.json;

  services.pulseeffects = {
    enable = true;
    preset = "WH-1000XM3";
  };

  programs.spicetify = {
    enable = true;
    theme = "Dribbblish";
    colorScheme = "dracula";
    enabledExtensions = [ "fullAppDisplay.js" "newRelease.js" ];
  };

  programs.zathura = {
    enable = true;
    extraConfig = builtins.readFile ../config/zathurarc;
  };
}
