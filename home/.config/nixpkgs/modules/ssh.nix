{ pkgs, ... }:

let
  hostsFile = ../config/ssh/hosts.nix;
  extraHosts = if builtins.pathExists hostsFile then import hostsFile else {};
in
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        extraOptions = {
          KexAlgorithms = "curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1";
        };
      };
    } // extraHosts;
    extraConfig = builtins.readFile ../config/ssh/config;
  };
}
