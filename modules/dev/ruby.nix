# [home-manager]
{config, ...}: {
  imports = [./mise.nix];

  home = {
    sessionVariables = {
      # Ruby
      OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
      DISABLE_SPRING = "true";
      RUBY_YJIT_ENABLE = 1;
      RUBY_CONFIGURE_OPTS = "--enable-yjit --with-jemalloc";
      BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
      BUNDLE_USER_CONFIG = "${config.xdg.configHome}/bundle/config";
      BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";
      RUBY_DEBUG_HISTORY_FILE = "${config.xdg.dataHome}/rdbg_history";
    };
    shellAliases = {
      puma-dev = "puma-dev --dir \"${config.xdg.configHome}/puma-dev\"";
    };
  };

  xdg.configFile = {
    "gem/gemrc".text = ''
      gem: --no-document
    '';
    "irb/irbrc".text = ''
      IRB.conf[:SAVE_HISTORY] ||= 1000
      IRB.conf[:PROMPT_MODE] = :SIMPLE
      IRB.conf[:AUTO_INDENT_MODE] = false
      IRB.conf[:HISTORY_FILE] ||= File.join(ENV["XDG_DATA_HOME"], "irb_history")
    '';
    "mise/default-gems".text = ''
      rails
    '';
  };

  # pin versions for better reproducibility
  programs.mise.globalConfig = {
    tools.ruby = "3.4.2";
    settings.idiomatic_version_file_enable_tools = ["ruby"];
    settings.ruby.default_packages_file = "${config.xdg.configHome}/mise/default-gems";
  };
}
