{
  config,
  pkgs,
  ...
}: let
  storageBox = 451930;
  mkShare = {
    subAccount ? null,
    extraOptions ? "",
  }: let
    username =
      if subAccount == null
      then "u${toString storageBox}"
      else "u${toString storageBox}-sub${toString subAccount}";
    shareName =
      if subAccount == null
      then "backup"
      else username;
    credentials = config.sops.secrets."storage-box/${username}".path;
  in {
    device = "//${username}.your-storagebox.de/${shareName}";
    fsType = "cifs";
    options = [
      "credentials=${credentials}"
      # Encrypt the connection
      "seal"
      # Use SMB3 when possible
      "vers=3.0"
      # "cache=loose"
      "fsc"
      # Default taken from Hetzner docs
      "iocharset=utf8,rw,file_mode=0660,dir_mode=0770"
      # Force systemd to consider this a network mount
      "_netdev,x-systemd.after=nss-lookup.target,x-systemd.wants=nss-lookup.target,nofail"
      extraOptions
    ];
  };
in {
  environment.systemPackages = [pkgs.cifs-utils pkgs.cachefilesd];
  services.cachefilesd.enable = true;

  sops.secrets."storage-box/u451930-sub1" = {};

  fileSystems."/mnt/seafile" = mkShare {
    subAccount = 1;
    extraOptions = "uid=991,gid=989";
  };

  systemd.services.seaf-server = {
    requires = ["mnt-seafile.mount" "mysql.service"];
    after = [
      "network.target"
      "mnt-seafile.mount"
      "mysql.service"
    ];
  };
}
