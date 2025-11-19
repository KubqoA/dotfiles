# TODO: pam-fprint-grosshack + possibly patch hyprlock to work without enter
#       https://github.com/hyprwm/hyprlock/compare/main...prochy-exe:hyprlock-grosshack:main
#       https://github.com/search?q=pam-fprint-grosshack+language%3ANix&type=code&l=Nix
{...}: {
  my.impermanence.directories = ["/var/lib/fprint"];

  services.fprintd.enable = true;
}
