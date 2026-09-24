{lib, ...}: {
  imports = lib.imports [
    "hm/base"
    "hm/ghostty"
    "hm/ssh"
    "hm/dev/js"
  ];

  programs.fish.interactiveShellInit = ''
    export GITHUB_PERSONAL_ACCESS_TOKEN="$(security find-generic-password -a $USER -s github-pat -w 2>/dev/null)"
  '';
}
