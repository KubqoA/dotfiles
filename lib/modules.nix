{ lib, ... }:

let
  inherit (builtins) attrValues pathExists readDir;
  inherit (lib) filterAttrs hasSuffix mapAttrs' mkDefault mkOption
                nameValuePair nixosSystem removeSuffix types;
  inherit (lib._) mapFilterAttrs attrValuesRec;
in rec {
  /* Reads the contents of the given ‹dir› and executes ‹fn› on ‹*.nix› files,
     except for ‹default.nix› and executes ‹dirfn› for directories. The results
     are stored as ‹nameValuePair› with the files/directories name as key.
     Serves as a helper function for ‹mapModules› and ‹mapModulesRec›.
     If the value returned by one of the functions is ‹null›, the key-value
     pair is discarded.

     Type:
       mapModules' :: String -> (String -> a) -> (Path -> a) -> AttrSet
     
     Example:
       mapModules' /folder lib.id lib.id
       => { subfolder = "/folder/subfolder"; file = "/folder/file.nix"; }
       Given that ‹/folder› only contains a file named ‹file.nix› and a folder
       named ‹subfolder›
  */
  mapModules' = dir: fn: dirfn:
    mapFilterAttrs
      (_: v: v != null)
      (name: type:
        let
          path = "${toString dir}/${name}";
        in
          if type == "directory" then
            nameValuePair name (dirfn path)
          else if type == "regular" && name != "default.nix" && hasSuffix ".nix" name then
            nameValuePair (removeSuffix ".nix" name) (fn path)
          else
            nameValuePair "" null
      )
      (readDir dir);

  mapModules = dir: fn: mapModules' dir fn (path: if pathExists "${path}/default.nix" then fn path else null);
  mapModulesRec = dir: fn: mapModules' dir fn (path: mapModulesRec path fn);
  mapModulesRec' = dir: fn: attrValuesRec (mapModulesRec dir fn);
}
