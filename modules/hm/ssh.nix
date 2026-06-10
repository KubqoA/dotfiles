{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      organ = {
        HostName = "organ.jakubarbet.me";
        User = "jakub";
        VerifyHostKeyDNS = "yes";
      };
      "*" = {
        SetEnv.TERM = "xterm-256color";
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
        GlobalKnownHostsFile = "/etc/ssh/ssh_known_hosts";
      };
    };
  };
}
