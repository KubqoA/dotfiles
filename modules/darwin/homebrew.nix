{
  lib,
  config,
  ...
}: let
  inherit (config.homebrew) brewPrefix;
in {
  # Sensible Homebrew defaults
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    # Don't quarantine apps installed by homebrew with gatekeeper
    caskArgs.no_quarantine = lib.mkDefault true;
  };

  environment = {
    systemPath = ["${brewPrefix}/bin" "${brewPrefix}/sbin"];

    variables = {
      HOMEBREW_NO_ANALYTICS = "1";

      HOMEBREW_PREFIX = brewPrefix;
      HOMEBREW_CELLAR = "${brewPrefix}/Cellar";
      HOMEBREW_REPOSITORY = "${brewPrefix}";
      INFOPATH = "${brewPrefix}/share/info:$INFOPATH";

      # Fix Homebrew libs
      LDFLAGS = "-L${brewPrefix}/lib";
      CPPFLAGS = "-I${brewPrefix}/include";
      RUSTFLAGS = "-L ${brewPrefix}/lib";
    };
  };

  # Install homebrew if it is not installed
  system.activationScripts.homebrew.text = lib.mkBefore ''
    if [[ ! -f "${brewPrefix}/brew" ]]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';
}
