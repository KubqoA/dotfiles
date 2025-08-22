# [home-manager]
# common aliases shared across all systems
{
  config,
  homeName,
  lib,
  system,
  ...
}: {
  home.shellAliases = let
    osCommand =
      {
        "x86_64-linux" = "sudo nixos-rebuild";
        "aarch64-linux" = "sudo nixos-rebuild";
        "aarch64-darwin" = "sudo darwin-rebuild";
      }
      .${
        system
      };
  in {
    cd = lib.mkIf config.programs.zoxide.enable "z";
    ls = "ls --color=tty";
    chx = "chmod +x";

    # Utils
    benchzsh = "hyperfine 'zsh -i -c exit' --warmup 1";
    hm = "home-manager --flake \"${config.dotfilesPath}#${homeName}\"";
    os = "${osCommand} --flake \"${config.dotfilesPath}\"";
    dots = "$EDITOR \"${config.dotfilesPath}\"";
    zd = "cd \"${config.dotfilesPath}\"";
    nix-gc = "nix-store --gc && hm expire-generations '-3 days' && nix-collect-garbage --delete-older-than 3d";
  };
}
