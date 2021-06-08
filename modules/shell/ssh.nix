{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.ssh;
  inherit (config.dotfiles) configDir;
in {
  options.modules.shell.ssh = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home._.programs.ssh = {
      enable = true;
      matchBlocks = let
        hostsFile = "${configDir}/ssh/hosts.nix";
        extraHosts = if builtins.pathExists hostsFile then import hostsFile else {};
      in {
        "github.com" = {
          extraOptions = {
            KexAlgorithms = "curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1";
          };
        };
      } // extraHosts;
      extraConfig = builtins.readFile "${configDir}/ssh/config";
    };
  };
}
