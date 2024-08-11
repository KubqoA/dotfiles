# Global configuration options that can be referenced by all modules
# Autoloaded as a module by `makeHome` and `makeSystem` functions
{
  config,
  lib,
  options,
  ...
}:
with lib; {
  options = {
    gitSigningKey = mkOption {type = types.str;};
    gpgSshControl = mkOption {type = types.str;};
  };

  config = {
    gitSigningKey = "4EB39A80B52672EC";
    gpgSshControl = "CC54AAD6EF69F323DEB5CDDF9521D2F679686C9E";
  };
}
