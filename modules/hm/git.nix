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

  home.shellAliases = {
    g = "git";
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
    linear = "git checkout -b (pbpaste)"; # TODO: pbpaste only works on macOS
  };
}
