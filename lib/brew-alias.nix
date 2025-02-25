{
  lib,
  pkgs,
  ...
}: {
  # On macOS creates a simple package that symlinks to a package installed by homebrew
  brew-alias = name:
    lib.mkIf pkgs.stdenv.isDarwin
    (pkgs.stdenv.mkDerivation {
      name = "${name}-brew";
      version = "1.0.0";
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        ln -s /opt/homebrew/bin/${name} $out/bin/${name}
      '';
      meta = with pkgs.lib; {
        mainProgram = "${name}";
        description = "Wrapper for Homebrew-installed ${name}";
        platforms = platforms.darwin;
      };
    });
}
