{...}: {
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 172800;
    maxCacheTtl = 172800;
  };

  home.shellAliases.importgpg = "bw get notes GPG | gpg --import && echo '990D46A4F8E4A895ACA14D6D883E485DBD16738C:6:' | gpg --import-ownertrust";
}
