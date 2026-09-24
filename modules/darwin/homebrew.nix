{
  config,
  homes,
  lib,
  ...
}: let
  brewPrefix = "/opt/homebrew";
  fromHomes = option: map (home: home.config.homebrew.${option}) homes;
in {
  # Sensible Homebrew defaults
  homebrew = {
    enable = true;

    # Homebrew is shared by all users, so install packages requested by home-manager configs of this host
    brews = lib.concatLists (fromHomes "brews");
    casks = lib.concatLists (fromHomes "casks");
    masApps = lib.mkMerge (fromHomes "masApps");

    onActivation = {
      autoUpdate = true;
      upgrade = true;

      cleanup = "zap";
    };
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
    if [[ ! -f "${brewPrefix}/bin/brew" ]]; then
      sudo -u ${config.username} /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';
}
