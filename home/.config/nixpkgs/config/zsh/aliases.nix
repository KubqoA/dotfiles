{
  windows = "sudo efibootmgr -n 0012 && reboot";
  sysu = "systemctl --user";
  ls = "ls --color=auto -F";
  chx = "chmod +x";
  term = "alacritty &";
  sudo = "doas";

  # git
  gad = "git add .";
  gc = "git commit";
  gcan = "git commit --amend -a --no-edit";
  gri = "git rebase --interactive";
  grc = "git rebase --continue";
  gra = "git rebase --abort";
  gprm = "git pull origin master --rebase";
  gpr = "git pull origin main --rebase";
  gp = "git push";
  gfp = "git push --force";
  
  # nix
  hme = "home-manager edit";
  purgehm = "home-manager expire-generations now";
  os = "doas vim /etc/nixos";
  newos = "doas nixos-rebuild switch";
  upgradeos = "doeas nix-channel --update && doas nixos-rebuild switch --upgrade";
  nixgc = "doas nix-collect-garbage -d";
  dbs = "doas vim /etc/nixos/databases.nix";
}
