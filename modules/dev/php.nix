# [home-manager]
{pkgs, ...}: {
  home.packages = with pkgs; let
    phpEnv = php84.buildEnv {
      extensions = {
        enabled,
        all,
      }:
        enabled ++ (with all; [ctype curl dom fileinfo mbstring openssl pdo session tokenizer]);
    };
  in [
    phpEnv
    phpEnv.packages.composer
    phpactor
  ];
}
