{
  lib,
  pkgs,
  ...
}: {
  programs.gpg.enable = true;

  services.gpg-agent = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    defaultCacheTtl = 172800;
    maxCacheTtl = 172800;
  };

  # Set up gpg agent configuration, home-manager gpg-agent module is not
  # supported on macOS
  home.file.".gnupg/gpg-agent.conf".text = lib.mkIf pkgs.stdenv.isDarwin ''
    default-cache-ttl 172800
    max-cache-ttl 172800
    pinentry-program /opt/homebrew/bin/pinentry-mac
  '';

  home.shellAliases.importgpg = "bw get notes GPG | gpg --import && echo '990D46A4F8E4A895ACA14D6D883E485DBD16738C:6:' | gpg --import-ownertrust";
}
