{lib, ...}: {
  autoloadedModules = let
    optionsDir = ../modules/autoload;
    nixFiles = lib.filterAttrs (n: _: lib.hasSuffix ".nix" n) (builtins.readDir optionsDir);
  in
    map (file: optionsDir + "/${file}") (builtins.attrNames nixFiles);
}
