{ lib, ... }:

let
  inherit (builtins) attrValues readFile;
  inherit (lib) concatStringsSep filterAttrs fold isAttrs mapAttrs' mkOption types;
in rec {
  /* Map over ‹attrs› with ‹f› and then filter them using ‹pred›

     Type:
       mapFilterAttrs ::
         (String -> a -> Bool) -> (String -> b -> AttrSet) -> AttrSet' -> AttrSet
       where AttrSet' has a value of type ‹b› and AttrSet of type ‹a›

     Example:
       mapFilterAttrs (n: v: n == "foo" || v == "bar") (n: v: nameValuePair n v)
                      { foo = "baz"; a = "bar"; b = "foo" };
       => { foo = "baz"; a = "bar"; }
  */
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);

  /* Recursively generates a list of values of ‹attr› even for nested attrs

     Type:
       attrValuesRec :: AttrSet -> [x]

     Example:
       attrValuesRec { foo = { bar = "baz"; }; a = "b"; }
       => ["baz" "b"]
  */
  attrValuesRec = attr: fold (x: xs: (if isAttrs x then attrValuesRec x else [x]) ++ xs) [] (attrValues attr);

  /* Filter the ‹self› key from the given ‹attr›

     Type:
       filterSelf :: AttrSet -> AttrSet
     
     Example:
       filterSelf { foo = "bar"; self = "baz"; }
       => { foo = "bar"; }
  */
  filterSelf = attr: filterAttrs (n: _: n != "self") attr;

  /* Maps the items of ‹list› to strings and concatenates them with ‹sep› in
     between the individual items

     Type:
       joinWithSep :: [a] -> String -> String
       ‹a› should be a type that is convertable to string using ‹toString›
     
     Example:
       joinWithSep [ 42 "foo" 0 ] "-"
       => "42-foo-0"
  */
  joinWithSep = list: sep: concatStringsSep sep (map toString list);

  /* Reads the given ‹path› and appends the ‹extras› to it

     Type:
       configWithExtras :: Path -> String -> String
     
     Example:
       configWithExtras example.txt "Appended text"
       => "Some text from example\nAppended text"
       Given that ‹example.txt› contains "Some text from example"
  */
  configWithExtras = path: extras: "${readFile path}\n${extras}";

  enable = { enable = true; };

  /* A simplifiation for creating options
     
     Example:
       mkOpt types.str "foobar" "A very important option"
       => mkOption {
            type = types.str;
            default = "foobar";
            description = "A very important option";
          }
  */
  mkOpt = type: default: description:
    mkOption { inherit type default description; };

  /* Creates option without description */
  mkOpt' = type: default: mkOpt type default null;

  /* Alias for ‹mkOpt' types.bool› */
  mkBoolOpt = default: mkOpt' types.bool default;
}
