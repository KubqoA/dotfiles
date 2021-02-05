{
  windows = "sudo efibootmgr -n 0012 && reboot";
  sysu = "systemctl --user";
  ls = "ls --color=auto -F";
  chx = "chmod +x";
  term = "alacritty &";

  # git
  gcan = "git commit --amend -a --no-edit";
  gri = "git rebase --interactive";
  grc = "git rebase --continue";
  gra = "git rebase --abort";
  gprm = "git pull origin master --rebase";
  gpr = "git pull origin main --rebase";
  
  # nix
  hme = "home-manager edit";
  os = "doas vim /etc/nixos";
  newos = "doas nixos-rebuild switch";
  dbs = "doas vim /etc/nixos/databases.nix";
  wlan = "doas vim /etc/nixos/wireless.nix";
}
