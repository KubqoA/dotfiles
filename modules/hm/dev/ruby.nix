{
  config,
  pkgs,
  ...
}: let
  commonRubyConfigureOpts = "--with-jemalloc --disable-install-doc --enable-yjit";

  osSepcificVars =
    if pkgs.stdenv.isDarwin
    then {
      RUBY_CONFIGURE_OPTS = commonRubyConfigureOpts;
    }
    else {
      CPPFLAGS = builtins.concatStringsSep " " [
        "-I${pkgs.openssl.dev}/include"
        "-I${pkgs.libffi.dev}/include"
        "-I${pkgs.readline.dev}/include"
        "-I${pkgs.zlib.dev}/include"
        "-I${pkgs.libyaml.dev}/include"
        "-I${pkgs.gmp.dev}/include"
        "-I${pkgs.jemalloc}/include"
      ];
      LDFLAGS = builtins.concatStringsSep " " [
        "-L${pkgs.openssl.out}/lib"
        "-L${pkgs.libffi.out}/lib"
        "-L${pkgs.readline.out}/lib"
        "-L${pkgs.zlib.out}/lib"
        "-L${pkgs.libyaml.out}/lib"
        "-L${pkgs.gmp.out}/lib"
        "-L${pkgs.jemalloc}/lib"
      ];
      PKG_CONFIG_PATH = builtins.concatStringsSep ":" [
        "${pkgs.openssl.dev}/lib/pkgconfig"
        "${pkgs.libffi.dev}/lib/pkgconfig"
        "${pkgs.readline.dev}/lib/pkgconfig"
        "${pkgs.zlib.dev}/lib/pkgconfig"
        "${pkgs.libyaml.dev}/lib/pkgconfig"
        "${pkgs.gmp.dev}/lib/pkgconfig"
      ];
      RUBY_CONFIGURE_OPTS = builtins.concatStringsSep " " [
        "--with-openssl-dir=${pkgs.openssl.dev}"
        "--with-readline-dir=${pkgs.readline.dev}"
        "--with-libffi-dir=${pkgs.libffi.dev}"
        "--with-zlib-dir=${pkgs.zlib.dev}"
        "--with-libyaml-dir=${pkgs.libyaml.dev}"
        "--with-gmp-dir=${pkgs.gmp.dev}"
        commonRubyConfigureOpts
      ];
    };
in {
  imports = [./mise.nix];

  home = {
    sessionVariables =
      {
        # Ruby
        OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
        DISABLE_SPRING = "true";
        BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
        BUNDLE_USER_CONFIG = "${config.xdg.configHome}/bundle/config";
        BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";
        IRBRC = "${config.xdg.configHome}/irb/irbrc";
        RUBY_DEBUG_HISTORY_FILE = "${config.xdg.dataHome}/rdbg_history";
        RUBY_YJIT_ENABLE = 1;
        SOLARGRAPH_CACHE = "${config.xdg.cacheHome}/solargraph";
        THOR_DIFF = "meld";
        THOR_MERGE = "meld"; # explore using nvim as alternative
      }
      // osSepcificVars;

    shellAliases = {
      puma-dev = "puma-dev --dir \"${config.xdg.configHome}/puma-dev\"";
    };

    # Required build tools
    packages = with pkgs; [
      gcc
      gnumake
      pkg-config
      autoconf
      bison
    ];
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
    tools.ruby = "3.4.7";
    settings.idiomatic_version_file_enable_tools = ["ruby"];
    settings.ruby.default_packages_file = "${config.xdg.configHome}/mise/default-gems";
  };

  programs.git.ignores = [".ruby-lsp"];
}
