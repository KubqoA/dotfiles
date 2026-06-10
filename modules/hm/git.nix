{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    ignores = [
      ".DS_Store"
      ".idea"
      ".vscode"
      ".zed"
      ".cursor"
    ];
    settings = {
      user = {
        name = "Jakub Arbet";
        email = "hi@jakubarbet.me";
      };
      init.defaultBranch = "main";
    };
  };

  programs.fish = {
    functions.gup = ''
      set branch (git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")
      git pull origin $branch --rebase
    '';

    shellAbbrs = {
      g = "git";

      gb = "git switch";
      gnb = "git switch -c";
      gprev = "git switch -";

      ga = "git add";
      gaa = "git add -A";
      gau = "git add -u";
      gus = "git restore --staged .";

      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit --amend";
      gcan = "git commit --amend --no-edit";

      gl = "git log --oneline -10";

      gp = "git push";
      gpo = "git push -u origin HEAD";
      gfp = "git push --force-with-lease";
      gpl = "git pull --rebase";
      gf = "git fetch";

      gri = "git rebase -i";
      grc = "git rebase --continue";
      gra = "git rebase --abort";
      grs = "git rebase --skip";

      gr1 = "git reset HEAD~1";
      grh1 = "git reset --hard HEAD~1";

      gs = "git stash";
      gsp = "git stash pop";

      gst = "git status -sb";

      linear = "git checkout -b (pbpaste)"; # TODO: pbpaste only works on macOS
    };
  };
}
