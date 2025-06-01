# [nixos/nix-darwin]
# automatically set hostName if it's present in the args
# hostName is added by mapHosts in bootstrap.nix
{lib, ...} @ args:
lib.optionalAttrs (args ? hostName) {
  networking.hostName = args.hostName;
}
