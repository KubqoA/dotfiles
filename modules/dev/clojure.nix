{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.clojure;
  inherit (config.dotfiles) configDir;
in {
  options.modules.dev.clojure = {
    enable = _.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      clojure
      clojure-lsp
      clj-kondo
      joker
      babashka
      jdk11
      leiningen
    ];

    home.configFile."clojure/deps.edn".source = "${configDir}/clojure/deps.edn";
  };
}
