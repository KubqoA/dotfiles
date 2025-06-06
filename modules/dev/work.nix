# [home-manager]
{config, ...}: let
  baseDir = "${config.home.homeDirectory}/Work";
in {
  programs.fish.functions = {
    prod = "fish -c \"cd ${baseDir}/(basename $PWD); git checkout main; git pull; bin/production $argv\"";
    staging = "fish -c \"cd ${baseDir}/(basename $PWD); git checkout main; git pull; bin/staging $argv\"";
    wt = ''
      set ruby_version (cat ${baseDir}/infrastructure-as-ruby/.ruby-version)
      mise x ruby@$ruby_version -- ruby ${baseDir}/infrastructure-as-ruby/recipes/development/containerized_dev_environment/instances/new_worktree.rb \
        --use-main \
        --base-path "${baseDir}" \
        --betterstack-path "${baseDir}/betterstack" \
        --uptime-path "${baseDir}/uptime" \
        --telemetry-path "${baseDir}/telemetry" \
        --name $argv
    '';
    wtc = ''
      set ruby_version (cat ${baseDir}/infrastructure-as-ruby/.ruby-version)
      mise x ruby@$ruby_version -- ruby ${baseDir}/infrastructure-as-ruby/recipes/development/instances/worktree_cleanup_instance.rb \
        --worktree-path "${baseDir}" \
        --betterstack-path "${baseDir}/betterstack" \
        --uptime-path "${baseDir}/uptime" \
        --telemetry-path "${baseDir}/telemetry"
    '';
    wtz = ''
      z ${baseDir}/worktree-default/$argv
    '';
    linear = ''
      set branch $argv[1]
      if test -z "$branch"
          set branch (pbpaste)
      end

      git fetch
      git switch -c $branch origin/main
    '';
  };
}
