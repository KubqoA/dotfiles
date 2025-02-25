# [home-manager]
{...}: {
  home = {
    sessionVariables = {
      IAC_PATH = "$HOME/Documents/betterstack/infrastructure-as-code";
    };

    shellAliases = {
      linear = "git checkout main && git pull && git checkout -b $(pbpaste)";
      swarm = "mise x ruby@$(cat $IAC_PATH/.ruby-version) -- $IAC_PATH/exe/swarm";
      prod-deploy = "git checkout main && git pull && swarm production deploy";
      staging-deploy = "git checkout main && git pull && swarm staging deploy";
    };
  };
}
