# Lib

The `default.nix` defines a lib extended with a `_` attribute under which mine
custom lib functions live. The `default.nix` loads every `.nix` file in the
`libs` (current) directory and imports it.

The importing is quite simple:
1. First the `libsInFolder` reads the contents of the `libs` directory, filters
   out non `.nix` files and the `default.nix` file and then returns a list of
   paths to the individual `.nix` files it found.
2. This list gets passed to `importLibs` which imports the libraries and
   merges the individual imported attribute sets together, so that all the
   functions are available directly under one attribute set.
3. This attribute then gets bind to the `_` attribute in the `lib` extension.

Individual `.nix` files can use the functions defined in other local library
files normally using the `nix._.someFunctionName`.

## Overview
TODO
