let
  pkgs = import <nixpkgs> {};
in name: src: env: pkgs.stdenv.mkDerivation {
  name = name;
  script = pkgs.substituteAll (env // {
    src = src;
    isExecutable = true;
  });
  buildCommand = ''
    install -Dm755 $script $out/bin/${name}
    patchShebangs $out/bin/${name}
  '';
}
