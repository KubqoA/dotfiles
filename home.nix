{ pkgs, ... }:

{
  home = {
    username = "jakub";
    homeDirectory = "/home/jakub";
    packages = with pkgs; [
      foot
      home-manager
      chromium
      firefox
      pass
      git
    ];
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 172800;
    maxCacheTtl = 172800;
    defaultCacheTtlSsh = 172800;
    maxCacheTtlSsh = 172800;
    pinentryFlavor = "gnome3";
    sshKeys = [ "CC54AAD6EF69F323DEB5CDDF9521D2F679686C9E" ];
  };

  programs.password-store = {
    enable = true;
#    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };

  xdg.enable = true;

  home.stateVersion = "23.11";
}
