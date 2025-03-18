{
  hostName ? null,
  lib,
  ...
}: {
  networking.hostName = lib.mkIf (hostName != null) hostName;
}
