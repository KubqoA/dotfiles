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
    ls =
      if config.programs.eza.enable
      then "eza -lh --group-directories-first --icons=auto"
      else "ls --color=tty";
    lsa = "ls -a";
    lt = lib.mkIf config.programs.eza.enable "eza --tree --level=2 --long --icons --git";
    lta = lib.mkIf config.programs.eza.enable "lt -a";
    ff = lib.mkIf (config.programs.fzf.enable && config.programs.bat.enable) "fzf --preview 'bat --style=numbers --color=always {}'";

    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    chx = "chmod +x";

    # Utils
    hm = "home-manager --flake \"${config.dotfilesPath}#${homeName}\"";
    os = "${osCommand} --flake \"${config.dotfilesPath}\"";
    dots = "$EDITOR \"${config.dotfilesPath}\"";
    zd = "cd \"${config.dotfilesPath}\"";
    nix-gc = "nix-store --gc && hm expire-generations '-3 days' && nix-collect-garbage --delete-older-than 3d";
  };
}
