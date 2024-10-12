{
  config,
  lib,
  inputs,
  system,
  ...
}: let
  pkgs = import inputs.darwin-nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in {
  launchd = let
    script = pkgs.writeShellApplication {
      name = "dark-mode-onswitch";
      text = ''
        case "$DARKMODE" in
          0)
            ${config.theme.dark.onSwitch}
            ;;
          1)
            ${config.theme.light.onSwitch}
            ;;
        esac
      '';
    };
  in {
    enable = true;
    agents.dark-mode-notify = {
      enable = true;
      config = {
        ProgramArguments = [
          (lib.getExe pkgs.dark-mode-notify)
          (lib.getExe script)
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/dark-mode-notify.stdout";
        StandardErrorPath = "/tmp/dark-mode-notify.stderr";
        ProcessType = "Background";
      };
    };
  };
}
