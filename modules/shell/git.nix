{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = _.mkBoolOpt false;
    userName = _.mkOpt' types.str "Jakub Arbet";
    userEmail = _.mkOpt' types.str "hi@jakubarbet.me";
    signingKey = _.mkOpt' types.str "990D46A4F8E4A895ACA14D6D883E485DBD16738C";
  };

  config = mkIf cfg.enable {
    home._.programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      signing.key = cfg.signingKey;
      signing.signByDefault = true;
      ignores = [
        "/.vscode"
        "/.lsp"
        ".nrepl-port"
        ".direnv"
        "/.clangd"
        "compile_commands.json"
      ];
      aliases = {
        last = "log -1 HEAD";
      };
      extraConfig = {
        color.ui = true;
        pull.rebase = true;
        url."git@github.com:".insteadOf = [ "https://github.com/" ];
        init.defaultBranch = "main";
      };
      delta.enable = true;
    };
  };
}
