# [home-manager]
{...}: {
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 172800;
    maxCacheTtl = 172800;
  };
}
