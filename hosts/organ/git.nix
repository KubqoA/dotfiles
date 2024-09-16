{
  config,
  lib,
  pkgs,
  ...
}: {
  age.secrets = lib._.defineSecrets [] {
    "organ-git-ssh-key" = {
      owner = "git";
      mode = "0600";
    };
  };

  users.users.git = {
    isNormalUser = true;
    description = "soft-serve proxy user";
    shell = let
      soft-serve-proxy = pkgs.writeShellScriptBin "soft-serve-proxy" ''
        #!/bin/bash
        if [ "$1" = "-c" ]; then
          shift
          exec ${pkgs.openssh}/bin/ssh -p 23231 localhost "$@"
        else
          exec ${pkgs.openssh}/bin/ssh -p 23231 localhost "$@"
        fi
      '';
    in "${soft-serve-proxy}/bin/soft-serve-proxy";
  };

  system.activationScripts.git-ssh-key = let
    sshDir = "${config.users.users.git.home}/.ssh";
  in ''
    mkdir -p ${sshDir}
    chown -R git:users ${sshDir}
    chmod 700 ${sshDir}
    ln -sf ${config.age.secrets.organ-git-ssh-key.path} ${sshDir}/id_ed25519;
  '';

  services = {
    nginx.virtualHosts."git.jakubarbet.me" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:23232";
      };
    };
    soft-serve = {
      enable = true;
      settings = {
        name = "Jakub's repos";
        ssh.public_url = "ssh://git@organ.jakubarbet.me";
        http.public_url = "https://git.jakubarbet.me";
        initial_admin_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICccFGBTx80CNOVaPBGxO9HzuAZ8rKTy7Ua6ZKJBLXev"];
      };
    };
  };
}
