{lib, ...}: {
  imports = lib.imports [
    "hm/base"
    "hm/ghostty"
    "hm/macos"
    "hm/ssh"
    "hm/dev/js"
  ];

  my = {
    dock = [
      "/Applications/Helium.app"
      "/Applications/Ghostty.app"
      "/Applications/Zed.app"
      "/Applications/Spotify.app"
      "/Applications/Slack.app"
    ];
    uuid = "B1819449-1EB0-4B20-9148-5DBE2695842B";
  };

  programs.fish.interactiveShellInit = ''
    export GITHUB_PERSONAL_ACCESS_TOKEN="$(security find-generic-password -a $USER -s github-pat -w 2>/dev/null)"
  '';
}
