# [home-manager]
# common env variables shared across all systems
{...}: {
  home.sessionVariables = rec {
    EDITOR = "nvim";
    GIT_EDITOR = EDITOR;
  };
}
