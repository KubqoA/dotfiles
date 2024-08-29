# [home-manager]
# common aliases shared across all systems
{
  config,
  lib,
  ...
}: {
  home.shellAliases = {
    cd = lib.mkIf config.programs.zoxide.enable "z";
    ls = "ls --color=tty";
    chx = "chmod +x";

    # Git
    gc = "git commit";
    gcm = "git commit -m";
    gca = "git commit --amend";
    gcan = "git commit --amend --no-edit";
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

    # Utils
    benchzsh = "hyperfine 'zsh -i -c exit' --warmup 1";
  };
}
