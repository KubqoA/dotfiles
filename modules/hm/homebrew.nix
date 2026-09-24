# Copy of nix-darwin's `homebrew.{brews,casks,masApps}` options for home configs.
# Homebrew is shared by all users on macOS, so these are collected and installed by the darwin host config.
{lib, ...}:
with lib; let
  # The shape is loose on purpose, nix-darwin validates the packages when building the host config
  packages = mkOption {
    type = types.listOf (types.either types.str types.attrs);
    default = [];
  };
in {
  options.homebrew = {
    brews = packages;
    casks = packages;
    masApps = mkOption {
      type = types.attrsOf types.ints.positive;
      default = {};
    };
  };
}
