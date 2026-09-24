{lib, ...}: {
  imports = lib.imports ["darwin/base" "darwin/ruby"];

  # home-manager on darwin doesn't support gpg-agent service, so it needs to be enabled here
  programs.gnupg.agent.enable = true;

  homebrew = {
    brews = [
      "pinentry-mac"

      {
        name = "postgresql@18";
        restart_service = "changed";
      }
      {
        name = "mariadb";
        restart_service = "changed";
      }
      {
        name = "valkey";
        restart_service = "changed";
      }
    ];

    # Hardware and system-level apps, user apps are declared in the home configs
    casks = [
      "imaging-edge-webcam"
      "keyboardcleantool"
      "logi-options+"
      "private-internet-access"
    ];
  };
}
