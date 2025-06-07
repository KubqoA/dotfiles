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

    # Git
    gad = "git add .";
    gc = "git commit";
    gcm = "git commit -m";
    gca = "git commit --amend";
    gcan = "git commit --amend --no-edit";
    gcl = "git clone";
    gp = "git push";
    gpo = "git push -u origin HEAD";
    gfp = "git push --force";
    gf = "git fetch";
    grm = "git pull origin main --rebase";
    gri = "git rebase -i";
    grc = "git rebase --continue";
    gra = "git rebase --abort";
    grs = "git rebase --skip";
    gb = "git checkout";
    gnb = "git checkout -b";
    gprev = "git checkout -";
    gr = "git reset HEAD~";
    grh = "git reset --hard HEAD~";
    gclean = "git restore --staged .";
    gs = "git stash";
    gsp = "git stash pop";

    # Utils
    benchzsh = "hyperfine 'zsh -i -c exit' --warmup 1";
    hm = "home-manager --flake \"${config.dotfilesPath}#${homeName}\"";
    os = "${osCommand} --flake \"${config.dotfilesPath}\"";
    dots = "$EDITOR \"${config.dotfilesPath}\"";
    zd = "cd \"${config.dotfilesPath}\"";
    nix-gc = "nix-store --gc && hm expire-generations '-3 days' && nix-collect-garbage --delete-older-than 3d";
  };
}
