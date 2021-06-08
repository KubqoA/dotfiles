#  _ _ _     
# | (_) |__  
# | | | '_ \ 
# | | | |_) |
# |_|_|_.__/ 
#            

{ inputs, lib, pkgs, ... }:

lib.extend (lib: super:
  let
    inherit (builtins) attrNames map readDir;
    inherit (lib) filterAttrs foldr hasSuffix;

    importLib = file: import file { inherit inputs lib pkgs; };
    merge = foldr (a: b: a // b) {};
    importLibs = libs: merge (map importLib libs);

    isLib = name: type: type == "regular" && name != "default.nix" && hasSuffix ".nix" name;
    libPath = name: "${toString ./.}/${name}";
    libsInFolder = map libPath (attrNames (filterAttrs isLib (readDir ./.)));
  in {
    _ = importLibs libsInFolder;
  }
)
