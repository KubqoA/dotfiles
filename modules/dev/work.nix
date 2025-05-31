# [home-manager]
{...}: {
  home = {
    shellAliases = {
      linear = "git checkout main && git pull && git checkout -b $(pbpaste)";
      prod-deploy = "git checkout main && git pull && ./bin/production deploy";
      staging-deploy = "git checkout main && git pull && ./bin/staging deploy";
    };
  };
}
