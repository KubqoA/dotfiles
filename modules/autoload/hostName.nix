{lib, ...} @ args:
lib.optionalAttrs (args ? hostName) {
  networking.hostName = args.hostName;
}
