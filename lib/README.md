# lib

Library has two important functions:

1. Moves configuration boilerplate out of the main `flake.nix` by providing
   `macosHome`, `linuxHome-x86`, `linuxHome-arm64`, `macosSystem`,
   `nixosSystem-x86` and `nixosSystem-arm64` functions to define home-manager
   and system configurations

2. Autoloads [`config.nix`](../config.nix) and [agenix](https://github.com/ryantm/agenix),
   as well as all `.nix` files in the [`modules/autoload`](../modules/autoload)
   directory for all home-manager and system configurations

3. Autoloads other `.nix` files in the `lib` directory and makes them available
   as extension to the default `lib` under the `_` namespace

## `lib` extensions

### `lib._.moduleImports`
Helper to make it easier to import modules from the `modules` directory.
Automatically includes `.nix` suffix for supplied paths, where necessary.

```nix
{lib, ...}: {
  imports = lib._.moduleImports [
    "common/git"
    "common/zsh"
    # ...
  ];
}
```

### `lib._.defineSecrets`
Helper to define agenix secrets in a more concise way.

```nix
{lib, ...}: {
  age.secrets = lib._.defineSecrets ["secret1" "secret2"] {
    secret3 = {owner = "foobar";};
  };

  # produces equivalent configuration to
  # age.secrets = {
  #   secret1.file = ../secrets/secret1.age;
  #   secret2.file = ../secrets/secret2.age;
  #   secret3 = {
  #     file = ../secrets/secret3.age;
  #     owner = "foobar";
  #   };
  # }
}
```
