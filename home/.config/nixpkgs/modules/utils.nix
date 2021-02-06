{ pkgs, ... }:

let
  comma = pkgs.callPackage (pkgs.fetchgit {
    url = "https://github.com/Shopify/comma";
    rev = "4a62ec17e20ce0e738a8e5126b4298a73903b468";
    sha256 = "0n5a3rnv9qnnsrl76kpi6dmaxmwj1mpdd2g0b4n1wfimqfaz6gi1";
  }) {};
in
{
  home.packages = [ comma ];

  programs.alacritty = {
    enable = true;
    settings = {
      window.padding = { x = 10; y = 10; };
      font.normal.family = "SF Mono";
      font.size = 11.0;
      font.offset.y = 3;
      colors.primary = {
        background = "#0f0b0a";
        foreground = "#f9fafb";
      };
      background_opacity = 0.9;
    };
  };

  programs.home-manager.enable = true;

  programs.password-store = {
    enable = true;
    package = pkgs.pass-wayland.withExtensions (exts: [ exts.pass-otp ]);
  };

  home.file.".config/nwg-launchers" = {
    source = ../config/nwg-launchers;
    recursive = true;
  };

  programs.git = {
    enable = true;
    userName = "Jakub Arbet";
    userEmail = "hi@jakubarbet.me";
    signing.key = "990D46A4F8E4A895ACA14D6D883E485DBD16738C";
    signing.signByDefault = true;
    ignores = [ "/.idea" ];
    aliases = {
      last = "log -1 HEAD";
    };
    extraConfig = {
      color.ui = true;
      pull.rebase = true;
      url."git@github.com:".insteadOf = [ "https://github.com/" ];
      init.defaultBranch = "main";
    };
    delta.enable = true;
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 172800;
    maxCacheTtl = 172800;
    defaultCacheTtlSsh = 172800;
    maxCacheTtlSsh = 172800;
    pinentryFlavor = "qt";
    extraConfig = "display :0";
  };
}
