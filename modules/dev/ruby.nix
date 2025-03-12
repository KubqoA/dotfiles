# [home-manager]
{config, ...}: {
  imports = [./mise.nix];

  home.sessionVariables = {
    # Ruby
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
    DISABLE_SPRING = "true";
    RUBY_YJIT_ENABLE = 1;
    RUBY_CONFIGURE_OPTS = "--enable-yjit --with-jemalloc";
  };

  xdg.configFile = {
    "gem/gemrc".text = ''
      gem: --no-document
    '';
    "irb/irbrc".text = ''
      IRB.conf[:SAVE_HISTORY] ||= 1000
      IRB.conf[:PROMPT_MODE] = :SIMPLE
      IRB.conf[:AUTO_INDENT_MODE] = false
    '';
    "mise/default-gems".text = ''
      rails
    '';
  };

  # pin versions for better reproducibility
  programs.mise.globalConfig = {
    tools.ruby = "3.4.2";
    settings.ruby.default_packages_file = "${config.xdg.configHome}/mise/default-gems";
  };
}
