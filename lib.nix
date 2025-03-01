inputs: lib: _:
{
  autoloadedModules = let
    optionsDir = ./modules/autoload;
    nixFiles = lib.filterAttrs (n: _: lib.hasSuffix ".nix" n) (builtins.readDir optionsDir);
  in
    map (file: optionsDir + "/${file}") (builtins.attrNames nixFiles);

  # Helper to easily import modules in home/system configs
  imports = let
    modulePath = path:
      if builtins.isPath path
      then path
      else if builtins.pathExists ./modules/${path}
      then ./modules/${path}
      else ./modules/${path}.nix;
  in
    builtins.map modulePath;

  # On macOS creates a simple package that symlinks to a package installed by homebrew
  brew-alias = pkgs: name:
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

  defineSecrets = secrets: lib.mapAttrs (name: options: {file = ../secrets + "/${name}.age";} // options) secrets;
}
# Make sure to add lib extensions from inputs
// inputs.home-manager.lib
// inputs.nix-darwin.lib
