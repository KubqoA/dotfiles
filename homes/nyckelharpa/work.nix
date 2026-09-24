{lib, ...}: {
  imports = lib.imports [
    "hm/base"
    "hm/ghostty"
    "hm/macos"
    "hm/ssh"
    "hm/dev/js"
  ];

  # Obtain with `id -u work`
  uid = 502;

  my = {
    dock = [
      "/Applications/Helium.app"
      "/Applications/Ghostty.app"
      "/Applications/Zed.app"
      "/Applications/Spotify.app"
      "/Applications/Slack.app"
    ];
    uuid = "11B0141F-0259-41E4-8726-23F3ADBDC116";
  };

  # Installed system-wide by the nyckelharpa darwin config
  homebrew = {
    casks = [
      "beekeeper-studio"
      "httpie-desktop"
      "notion-calendar"
      "slack"
    ];

    masApps = {
      WireGuard = 1451685025;
    };
  };

  programs.fish.interactiveShellInit = ''
    export GITHUB_PERSONAL_ACCESS_TOKEN="$(security find-generic-password -a $USER -s github-pat -w 2>/dev/null)"
  '';
}
