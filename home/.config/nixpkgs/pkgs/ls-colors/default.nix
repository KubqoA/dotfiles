let
  pkgs = import <nixpkgs> {};
  LS_COLORS = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    rev = "e91cc9cc69f6c4780f03b121bc633569742de7cd";
    sha256 = "1i2pc9k1g79wvdq3w2h3ikp3s2myalcvwin2l6gmyhz5cn0xjfg8";
  };
in
  pkgs.runCommand "ls-colors" {} ''
    mkdir -p $out/bin $out/share
    ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls
    ln -s ${pkgs.coreutils}/bin/dircolors $out/bin/dircolors
    cp ${LS_COLORS}/LS_COLORS $out/share/LS_COLORS
  ''
