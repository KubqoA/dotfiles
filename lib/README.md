# lib

Library has two important functions:

1. Moves configuration boilerplate out of the main `flake.nix` by providing
   `macosHome`, `linuxHome`, `macosSystem` and `nixosSystem` functions to
   define home-manager and system configurations

2. Autoloads [`config.nix`](../config.nix) for all these configurations

3. Autoloads other `.nix` files in the `lib` directory and makes them available
   as extension to the default `lib` under the `_` namespace

## `lib` extensions

### `lib._.moduleImports`
Helper to make it easier to import modules from the `modules` directory.
Automatically includes `.nix` suffix for supplied paths, where necessary.

```nix
{ lib, ... }:
{
  imports = lib._.moduleImports [
    "common/git"
    "common/zsh"
    # ...
  ];

  # ...
}
```
