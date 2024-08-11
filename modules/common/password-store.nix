# [home-manager]
# password-store with otp support and custom store location
{pkgs, ...}: {
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
    settings.PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
  };
}
