# [home-manager]
{config, ...}: {
  imports = [./mise.nix];

  home.sessionVariables = {
    MISE_PYTHON_DEFAULT_PACKAGES_FILE = "${config.xdg.configHome}/mise/default-python-packages";
  };

  xdg.configFile = {
    "mise/default-python-packages".text = ''
      ruff
      setuptools
    '';
  };

  # pin versions for better reproducibility
  programs.mise.globalConfig.tools.python = "3.13";
}
