{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  programs.gpg.enable = true;

  services.gpg-agent = lib.mkIf (!isDarwin) {
    enable = true;
    defaultCacheTtl = 172800;
    maxCacheTtl = 172800;
  };

  # Set up GPG agent configuration, home-manager gpg-agent module is not
  # supported on macOS
  home.file = lib.mkIf isDarwin {
    ".gnupg/gpg-agent.conf".text = ''
      default-cache-ttl 172800
      max-cache-ttl 172800
      pinentry-program /opt/homebrew/bin/pinentry-mac
    '';
  };

  home.shellAliases.importgpg = "bw get notes GPG | gpg --import && echo '990D46A4F8E4A895ACA14D6D883E485DBD16738C:6:' | gpg --import-ownertrust";
}
