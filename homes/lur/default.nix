{lib, ...}: {
  imports = lib.imports [
    "hm/base"
    "hm/gpg"
    "hm/password-store"
    "hm/ssh"
    "hm/dev/js"
    "hm/dev/php"
    "hm/dev/python"
    "hm/dev/ruby"
    "hm/dev/rust"
  ];

  # Custom pinentry program taken from https://github.com/rupor-github/win-gpg-agent
  # TODO: Possibly turn into a nix package
  services.gpg-agent.extraConfig = ''
    pinentry-program /home/jakub/pinentry.exe
  '';
}
